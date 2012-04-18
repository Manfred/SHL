Gem::Specification.new do |spec|
  spec.name = 'shl'
  spec.version = '0.0.1'

  spec.author = "Manfred Stienstra"
  spec.email = "manfred@fngtps.com"

  spec.description = <<-EOF
    SHL is a really simple HTTP library.
  EOF
  spec.summary = <<-EOF
    SHL is a really simple HTTP library.
  EOF

  spec.files = ['lib/shl.rb', 'lib/shl/request.rb', 'lib/shl/response.rb']

  spec.has_rdoc = true
  # spec.extra_rdoc_files = ['README.md', 'LICENSE']
  spec.rdoc_options << "--charset=utf-8"

  spec.add_development_dependency('rake')
end
