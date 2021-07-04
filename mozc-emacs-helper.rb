require "formula"

class MozcEmacsHelper < Formula
  homepage "https://github.com/cafenero/homebrew-mozc-emacs-helper"
  url "https://gist.github.com/cef707ac0b23b82f399a.git"
  version "0.0.2"

  depends_on "ninja"
  # depends_on "python2"

  def install
    # org
    # system "svn co https://src.chromium.org/svn/trunk/tools/depot_tools"
    # system "./depot_tools/gclient config http://mozc.googlecode.com/svn/trunk/src"
    # system "./depot_tools/gclient sync"
    # system "patch src/build_mozc.py < build_mozc.py.patch"
    # system "python src/build_mozc.py gyp --noqt"
    # system "python src/build_mozc.py build -c Release src/mac/mac.gyp:GoogleJapaneseInput src/mac/mac.gyp:gen_launchd_confs src/unix/emacs/emacs.gyp:mozc_emacs_helper"

    # OS version
    # sw_vers | grep ProductVersion | awk '{print $2}'
    os_version = `sw_vers | grep ProductVersion | awk '{print $2}'`

    # SDK verson
    # xcodebuild -sdk -version | grep '^MacOSX11.3.sdk' | awk '{print $4}'
    # or
    # ls -d /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX1* | awk -F\/ '{print $NF}' | sed -e 's/MacOSX//g' -e 's/\.sdk//g'
    sdk_version = `xcodebuild -sdk -version | grep '^MacOSX11.3.sdk' | awk '{print $4}'`

    # debug
    # system "cp -r ~/mozc ."
    system "git clone https://github.com/google/mozc.git -b 2018-02-26 --single-branch --recursive"
    Dir.chdir "mozc" do

      # debug
      # system 'cp ~/mozc-emacs-helper.patch .'
      system 'curl -O https://raw.githubusercontent.com/cafenero/homebrew-mozc-emacs-helper/mod_build_for_python2/mozc-emacs-helper.patch'
      system "patch -p1 < mozc-emacs-helper.patch"

      Dir.chdir "src" do
        # debug
        # system "GYP_DEFINES='mac_sdk=11.3 mac_deployment_target=11.4' python2 build_mozc.py gyp --noqt --branding=GoogleJapaneseInput"
        system "GYP_DEFINES='mac_sdk=#{sdk_version} mac_deployment_target=#{os_version}' python2 build_mozc.py gyp --noqt --branding=GoogleJapaneseInput"
        system 'export PATH=$PATH:/usr/local/bin; python2 build_mozc.py build -c Release unix/emacs/emacs.gyp:mozc_emacs_helper'
        bin.install 'out_mac/Release/mozc_emacs_helper'
      end
    end
  end
end
