Pod::Spec.new do |s|

  s.name         = "ADMediatorCategory"
  s.version      = "3"
  s.summary      = "ADMediatorCategory."
  s.description  = <<-DESC
                    this is ADMediatorCategory
                   DESC

  s.homepage     = "https://github.com/ADModulization/ADMediatorCategory"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "naibin" => "binjiayou66@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ADModulization/ADMediatorCategory.git", :tag => s.version.to_s }

  s.source_files  = "ADMediatorCategory/ADMediatorCategory/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true

  s.dependency "ADMediator"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "CTAPIManagers"
  # s.dependency "CTMediator"

end
