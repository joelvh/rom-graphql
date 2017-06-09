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

        root_element_str = root_element ? "'#{root_element}'" : 'nil'
        class_eval <<-METHOD
          def #{name}(#{params.join(', ')})
            query = #{name.upcase}
            query_vars = { #{params.map { |var| "#{var}: #{var}" }.join(', ')}}
            values = dataset.query(query,  #{root_element_str}, {variables: query_vars})
            self.new(values)
          end
        METHOD
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
