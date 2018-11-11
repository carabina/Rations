Pod::Spec.new do |s|
  s.name             = 'Rations'
  s.version          = '0.1.0'
  s.summary          = 'A rational number type for Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/erikstrottmann/Rations'
  s.license          = { type: 'MIT', file: 'LICENSE.txt' }
  s.author           = { 'Erik Strottmann' => 'hello@erikstrottmann.com' }
  s.source           = { git: 'https://github.com/Erik Strottmann/Rations.git', tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/erikstrottmann'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/Rations/**/*'
end
