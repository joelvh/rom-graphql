# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ROM::GraphQL::Gateway do
  describe '.query' do
    subject { described_class.new('STUB URI').query(query, root_element) }

    let(:query) { 'Test query' }
    let(:errors) { nil }
    let(:response) { [] }
    let(:root_element) {}
    let(:connection) { instance_double(::GraphQL::Client) }

    before do
      allow(::GraphQL::Client::HTTP).to receive(:new).and_return(double)
      allow(::GraphQL::Client).to receive(:load_schema).and_return(double)
      allow(::GraphQL::Client).to receive(:new).and_return(connection)

      allow(connection).to receive(:query).with(query, {}).and_return(
        instance_double(::GraphQL::Client::Response, data: response, errors: errors)
      )
    end

    context 'with camelcased response' do
      let(:response) do
        {
          'testQuery' => {
            'camelCaseValue1' => 'STRING',
            'camelCaseValue2' => 1,
            'camelCaseValue3' => { 'subValue1' => 'TEST' },
            'camelCaseValue4' => [{ 'subValue1' => 'TEST' }]
          }
        }
      end

      let(:ruby_response) do
        [{
          'camel_case_value1' => 'STRING',
          'camel_case_value2' => 1,
          'camel_case_value3' => { 'sub_value1' => 'TEST' },
          'camel_case_value4' => [{ 'sub_value1' => 'TEST' }]
        }]
      end

      it { is_expected.to eq ruby_response }
    end

    context 'with a root element' do
      let(:response) do
        {
          'testQuery' => {
            'return1' => { 'value1' => 'TEST 1' },
            'return2' => { 'value2' => 'TEST 2' }
          }
        }
      end

      let(:ruby_response) do
        [{ 'value2' => 'TEST 2' }]
      end

      let(:root_element) { 'return2' }

      it { is_expected.to eq ruby_response }
    end

    context 'with an error' do
      let(:errors) { ['This is serious'] }
      specify { expect{subject}.to raise_error '["This is serious"]' }
    end
  end
end
