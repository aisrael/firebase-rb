require 'faraday'

module Firebase

  class Database

    attr_reader :session

    def initialize(session)
      @session = session
    end


    def ref(path)
      Reference.new(self, path)
    end

    def in_session(&block)
      yield session.client
    end

    class Reference
      attr_reader :database, :path

      def initialize(database, path)
        @database = database
        @path = path
      end

      def get
        @database.session.client.get(path)
      end
    end
  end

end
