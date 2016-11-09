require 'ostruct'

module Firebase

  class << self
    def initialize_app(params = {})
      App.new(params)
    end
  end

  require_relative 'firebase/session.rb'
  require_relative 'firebase/database.rb'

  class App

    extend Forwardable

    attr_reader :database_url, :service_account, :json, :logger

    def_delegators :@json, :private_key, :client_email

    def initialize(params = {})
      @database_url = params[:database_url] || raise('Parameter :database_url must be specified')
      @service_account = params[:service_account] || raise('Parameter :service_account must be specified')
      raise(%Q(Service account file "#{@service_account}" does not exist!)) unless File.exist?(@service_account)
      raise(%Q(Service account file "#{@service_account}" cannot be read!)) unless File.readable?(@service_account)

      @json = OpenStruct.new(JSON.load(File.open(service_account)))
    end

    def database
      @database || Database.new(session)
    end

    def session
      @session ||= Session.new(self)
    end

  end

end
