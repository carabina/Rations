Pod::Spec.new do |s|
  s.name             = 'Rations'
  s.version          = '0.1.0'
  s.summary          = 'A rational number type for Swift.'

  s.description      = <<-DESC
Rations is a rational number value type for Swift. It allows you to
perform calculations on fractional numbers without the loss of precision
caused by floating-point arithmetic. Rational numbers are useful for
representing currency and for other applications where exact results,
not approximations, are desired.
                       DESC

  s.homepage         = 'https://github.com/erikstrottmann/Rations'
  s.license          = { type: 'MIT', file: 'LICENSE.txt' }
  s.author           = { 'Erik Strottmann' => 'hello@erikstrottmann.com' }
  s.source           = { git: 'https://github.com/Erik Strottmann/Rations.git', tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/erikstrottmann'

  s.swift_version = '4.2'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/Rations/**/*'
end
