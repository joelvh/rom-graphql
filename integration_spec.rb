# frozen_string_literal: true

require 'spec_helper'

 class StarWarsRelation < ROM::GraphQL::Relation
    query :starships, [:length], nil, <<-'GRAPHQL'
        query($length: Int!) {
            allStarships(first:$length) {
            starships {
            name
  }
        }       
    }
    GRAPHQL
end 

RSpec.describe 'Integration Spec' do
    let(:rom) do
        configuration = ROM::Configuration.new(:graphql, "http://swapi.graphene-python.org/graphql?")
        configuration.register_relation(StarWarsRelation)
        ROM.container(configuration)
        rom
    end

    describe 'gets a list of addresses' do
        subject { rom.relations[:star_wars].startships(2).to_a }

        it { is_expected.to eq([])}
    end 
end