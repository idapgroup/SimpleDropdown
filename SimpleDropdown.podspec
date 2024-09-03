Pod::Spec.new do |s|
  s.name      = "SimpleDropdown"
  s.version   = "1.0.0"
  s.swift_version = "5.5"
  s.summary   = "Simple dropdown view"
  s.description  = "А simple dropdown that can be easily integrated into your app layout and customize to suit your design."
  s.homepage  = "https://github.com/idapgroup/SimpleDropdown"
  s.license   = { :type => "New BSD", :file => "LICENSE" }
  s.author    = { "IDAP Group" => "hello@idapgroup.com" }
  s.source    = { :git => "https://github.com/idapgroup/SimpleDropdown.git",
                  :tag => s.version.to_s }

  # Platform setup
  s.requires_arc          = true
  s.ios.deployment_target = '15.0'

  # Preserve the layout of headers in the Module directory
  s.header_mappings_dir   = 'Source'
  s.source_files          = 'Source/**/*.{swift,h,m,c,cpp}'
end
