# frozen_string_literal: true

require 'rom'

module ROM
  module GraphQL
    class Relation < ROM::Relation
      adapter :graphql

      def initialize(*args)
        super(*args)

        (self.class.instance_variable_get('@fragments') || {}).each do |(name, query_string)|
          self.class.const_set(name, dataset.parse(query_string))
        end
        self.class.instance_variable_set('@fragments', {})

        (self.class.instance_variable_get('@queries') || {}).each do |(name, query_string)|
          self.class.const_set(name.upcase, dataset.parse(query_string))
        end
        self.class.instance_variable_set('@queries', {})
      end

      def self.query(name, params, root_element, query_string)
        @queries ||= {}
        @queries[name] = query_string

        class_eval do
          define_method name do |*args|
            raise ArgumentError, "expected #{params.length} arguments, got #{args.length}" unless args.length == params.length
            query = self.class.const_get(name.upcase)
            query_vars = Hash[*params.zip(args).flatten]
           
            values = dataset.query(query,  root_element, {variables: query_vars})
            self.new(values)            
          end
        end
      end

      def self.fragment(name, query_string)
        @fragments ||= {}
        @fragments[name] = query_string
      end

      def base_name
        name
      end
    end
  end
end
