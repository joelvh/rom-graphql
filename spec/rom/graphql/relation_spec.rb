# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ROM::GraphQL::Relation do
  subject do
    klass = Class.new(ROM::GraphQL::Relation) do
      query :test_query, [:one_argument], nil, 'CRAZY STRING'
    end

    klass.new(dataset)
  end

  let(:dataset) { instance_double(ROM::GraphQL::Gateway) }
  let(:graphql_query_string) { 'CRAZY STRING' }
  let(:graphql_query) { 'PARSE QUERY' }

  before do
    allow(ROM.adapters).to receive(:fetch).with(:graphql)
                                          .and_return(instance_double(Class, const_get: 'STUB'))
    allow(dataset).to receive(:parse).with(graphql_query_string)
                                     .and_return(graphql_query)
  end

  it { is_expected.to respond_to(:test_query).with(1).argument }

  specify 'passes query argumentes' do
    expect(dataset).to receive(:query).with('PARSE QUERY', nil, variables: { one_argument: 'MY ARG' })
    subject.test_query('MY ARG')
  end

  specify 'returns values' do
    allow(dataset).to receive(:query).and_return(['HOLA'])
    expect(subject.test_query('MY ARG').one).to eq('HOLA')
  end
end
