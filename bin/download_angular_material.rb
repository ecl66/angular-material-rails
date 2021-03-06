require 'rubygems'
require 'open-uri'
require 'zip'
require 'fileutils'


def download_angular_material(angular_material_zip=nil)
  $VERBOSE = true
  size = ""
  angular_material_zip = 'https://github.com/angular/material2/archive/6.4.x.zip'
  puts "Get #{angular_material_zip}"
  open( angular_material_zip, 
    :content_length_proc => lambda {|t|
      if t && 0 < t
        size = t.to_s
      end
    },
    :progress_proc => lambda {|s|
      print "Downloading #{s} of #{size}                                                      \r"
    },
    "User-Agent" => "Mozilla/5.0 (X11; U; Linux; i686; en-US; rv:1.6) Gecko Debian/1.6-7","Referer" => "http://rubygems.org/gems/angular-material-rails") {|zf|
        Zip::File.open(zf.path) do |zipfile|
          zipfile.each{|e|
            unless e.to_s =~ /\.spec\.js$/
              print "Extracting #{e.to_s}                                        \r"
              fpath = File.join('angular-material', e.to_s)
              print "Path: #{fpath.to_s}"
              FileUtils.mkdir_p(File.dirname(fpath))
              zipfile.extract(e, fpath){ true }
            end
          }
        end
    }
  FileUtils.cp_r "angular-material/material2-6.4.x/src/.", "../vendor/assets/javascripts/angular-material"
  FileUtils.cp_r "angular-material/material2-6.4.x/src/.", "../vendor/assets/stylesheets/angular-material"
  val = %x(cd ../vendor/stylesheets; ls -a angular-material/*.scss | cut -d "." -f 1|awk '{print "@import \x27"$1"\x27;"}'  >angular-material-rails.scss; cd ..)
  val = %x(cd ../vendor/javascripts; ls -a angular-material/*.js | cut -d "." -f 1|awk '{print "@import \x27"$1"\x27;"}'  >angular-material-rails.js; cd ..)
  val = %x(cd ../vendor/javascripts; ls -a angular-material/*.js | cut -d "." -f 1|awk '{print "@import \x27"$1"\x27;"}'  >angular-material-rails.js.erb; cd ..)
  puts "Download and extract Angular Material [OK]                                                 "
end
