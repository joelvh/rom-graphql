# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/graphql/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-graphql'
  spec.version       = ROM::GraphQL::VERSION
  spec.authors       = ['Andreas Thurn']
  spec.email         = ['andreas@expert360.com']

  spec.summary       = 'GraphQL support for ROM'
  spec.description   = '<3'
  spec.homepage      = 'http://github.com/expert360/rom-graphql'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'graphql-client', '0.11.0'
  spec.add_dependency 'rom', '~> 3.2.2'
  spec.add_dependency 'activesupport', '> 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.15.1'
  spec.add_development_dependency 'byebug'
end
