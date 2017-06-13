# frozen_string_literal: true

require 'rom/graphql/version'
require 'rom/graphql/gateway'
require 'rom/graphql/relation'

ROM.register_adapter(:graphql, ROM::GraphQL)

module ROM
  module GraphQL
  end
end
