require 'faraday'
require 'jwt'
require 'openssl'
require 'active_support/all'

module Firebase

  class Session
    attr_reader :app

    def initialize(app)
      @app = app
      @token = nil
    end

    def token
      refresh_token if expired?
      @token
    end

    def expired?
      @token.nil? || @token.expired?
    end

    def client
      Client.new(self)
    end

    private

    def rsa_private_key
      @rsa_private_key ||= OpenSSL::PKey::RSA.new(app.private_key)
    end

    def refresh_token
      now = Time.now.to_i
      payload = {
          iss: app.client_email,
          scope: 'https://www.googleapis.com/auth/firebase.database https://www.googleapis.com/auth/userinfo.email',
          aud: 'https://www.googleapis.com/oauth2/v4/token',
          exp: now + 1.hour,
          iat: now
      }

      token_request = JWT.encode payload, rsa_private_key, 'RS256'
      token_request_string = token_request.to_s
      puts "token_request_string => #{token_request_string}"

      conn = Faraday.new do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      resp = conn.post 'https://www.googleapis.com/oauth2/v4/token', {
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: token_request_string
      }

      p resp
      puts resp.status
      json_resp = JSON.parse(resp.body)
      p json_resp
      @token = Token.new(json_resp)
    end

    public

    # A Session::Client, which exposes 'low-level' REST commands.
    # Really just a thin wrapper around Faraday
    class Client

      attr_reader :session

      def initialize(session)
        @session = session
        @conn = Faraday.new(session.app.database_url)
      end

      def get(path)
        resp = @conn.get do |req|
          req.path = path + '.json'
          req.headers['Authorization'] = "Bearer #{session.token.access_token}"
        end
        puts "GET #{path} => #{resp.status}"
        if resp.status == 200
          puts "resp.body = #{resp.body.inspect}"
          JSON.parse(resp.body, quirks_mode: true)
        end
      end

      def put(path, data)
        resp = @conn.put do |req|
          req.path = path + '.json'
          req.body = data.to_json
          req.headers['Authorization'] = "Bearer #{session.token.access_token}"
          req.headers['Accept'] = 'application/json'
          req.headers['Content-Type'] = 'application/json'
        end
        puts "PUT #{path} => #{resp.status}"
        if resp.status == 200
          return JSON.parse(resp.body)
        end
      end

      def push(path, data)
        resp = @conn.post do |req|
          req.path = path + '.json'
          req.body = data.to_json
          req.headers['Authorization'] = "Bearer #{session.token.access_token}"
          req.headers['Accept'] = 'application/json'
          req.headers['Content-Type'] = 'application/json'
        end
        puts "POST #{path} => #{resp.status}"
        if resp.status == 200
          return JSON.parse(resp.body)
        end
      end
    end

    # A thin, utility wrapper around the returned Google auth token
    class Token

      attr_reader :access_token, :token_type, :expires_in

      def initialize(json)
        @access_token = json['access_token']
        @token_type = json['token_type']
        @expires_in = Time.now + json['expires_in']
      end

      def expired?
        Time.now >= @expires_in
      end
    end

  end
end
