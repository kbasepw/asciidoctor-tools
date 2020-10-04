# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'asciidoctor/tools/version'

Gem::Specification.new do |s|
  s.name          = 'asciidoctor-tools'
  s.version       = Asciidoctor::Tools::VERSION
  s.summary       = 'Asciidoctor tools for authoring'
  s.description   = 'A set of tools and extensions based on asciidoctor.'
  s.authors       = ['KBase.pw']
  s.email         = ['core@kbase.pw']
  s.homepage      = 'https://github.com/kbasepw/asciidoctor-tools'
  s.licenses      = ['MIT']

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib', 'bin']
  s.executables   = ["extract-dependencies"]
  s.add_runtime_dependency "asciidoctor"
  s.add_runtime_dependency "asciidoctor-pdf"
  s.add_runtime_dependency "clamp"
end
