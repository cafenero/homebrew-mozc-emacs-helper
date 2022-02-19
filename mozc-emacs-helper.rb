require "formula"

class MozcEmacsHelper < Formula
  homepage "https://github.com/cafenero/homebrew-mozc-emacs-helper"
  url "https://github.com/cafenero/homebrew-mozc-emacs-helper/raw/add-bottle/bottle/mozc-emacs-helper--0.0.2.big_sur.bottle.1.tar.gz"
  sha256 "6d8f91b48ad8805bfec9f18e73a1d055fd7fb326d4e637f96a9762bdf53649d1"
  version "0.0.2"

  depends_on "ninja"
  # depends_on "python2"

  def install

    # OS version
    # sw_vers | grep ProductVersion | awk '{print $2}'
    os_version = `sw_vers | grep ProductVersion | awk '{print $2}'`

    # SDK verson
    # xcodebuild -sdk -version | grep '^MacOSX11.3.sdk' | awk '{print $4}'
    # or
    # ls -d /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX1* | awk -F\/ '{print $NF}' | sed -e 's/MacOSX//g' -e 's/\.sdk//g'
    sdk_version = `xcodebuild -sdk -version | grep '^MacOSX11.3.sdk' | awk '{print $4}'`


    ### binary install
    # if os_version == 11.4 and sdk_version == 11.3
    #   bin.install Binary => 'mozc_emacs_helper'
    # # bin.install 'out_mac/Release/mozc_emacs_helper'
    # else

    ### source install
    # debug
    # system "cp -r ~/mozc ."
    system "git clone https://github.com/google/mozc.git -b 2018-02-26 --single-branch --recursive"
    Dir.chdir "mozc" do

      # debug
      # system 'cp ~/mozc-emacs-helper.patch .'
      system 'curl -O https://raw.githubusercontent.com/cafenero/homebrew-mozc-emacs-helper/master/mozc-emacs-helper.patch'
      system "patch -p1 < mozc-emacs-helper.patch"

      Dir.chdir "src" do
        # debug
        # system "GYP_DEFINES='mac_sdk=11.3 mac_deployment_target=11.4' python2 build_mozc.py gyp --noqt --branding=GoogleJapaneseInput"
        system "GYP_DEFINES='mac_sdk=#{sdk_version} mac_deployment_target=#{os_version}' python2 build_mozc.py gyp --noqt --branding=GoogleJapaneseInput"
        system 'export PATH=$PATH:/usr/local/bin; python2 build_mozc.py build -c Release unix/emacs/emacs.gyp:mozc_emacs_helper'
        Dir.chdir "out_mac/Release" do
          # bin.install 'out_mac/Release/mozc_emacs_helper'
          bin.install 'mozc_emacs_helper'
        end
      end
    end

  end
end
