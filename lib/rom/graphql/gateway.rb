# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/try'
require 'rom'

module ROM
  module GraphQL
    class Gateway < ROM::Gateway
      attr_reader :logger
      attr_reader :options

      def initialize(uri, options = {})
        @http = ::GraphQL::Client::HTTP.new(uri)
        @schema = ::GraphQL::Client.load_schema(@http)
        @connection = ::GraphQL::Client.new(schema: @schema, execute: @http)
        @options = options
      end

      def query(query, root_element, args = {})
        response = @connection.query(query, args)
        raise response.errors.inspect if response.errors

        data = response.data.to_h
                       .deep_transform_keys(&:underscore)
                       .values

        if root_element
          data.map { |it| it.try(:dig, root_element) }.compact
        else
          data.compact
        end
      end

      def parse(query_string)
        @connection.parse(query_string)
      end

      def [](_name)
        self
      end

      def dataset(_name)
        self
      end

      def dataset?(_name)
        self
      end

      def use_logger(logger)
        @logger = logger
        connection.loggers << logger
      end
    end
  end
end
