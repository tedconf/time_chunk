# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'time_chunk'
  s.version = '1.0.0'

  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  s.authors = ['Alex Dean']
  s.date = '2013-05-17'
  s.description = 'Iterate over time ranges in discrete chunks.'
  s.email = 'alex@crackpot.org'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = [
    '.document',
    '.rspec',
    'Gemfile',
    'LICENSE.txt',
    'README.md',
    'Rakefile',
    'VERSION',
    'lib/time_chunk.rb',
    'spec/spec_helper.rb',
    'spec/time_chunk_spec.rb',
    'time_chunk.gemspec'
  ]
  s.homepage = 'http://github.com/tedconf/time_chunk'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.24'
  s.summary = 'Iterate over time ranges in discrete chunks.'

  s.add_development_dependency 'rspec', '~> 2.8.0'
  s.add_development_dependency 'rdoc', '~> 3.12'
  s.add_development_dependency 'bundler', '~> 1.2.0'
end
