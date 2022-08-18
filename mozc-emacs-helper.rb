require "formula"

class MozcEmacsHelper < Formula
  homepage "https://github.com/cafenero/homebrew-mozc-emacs-helper"
  url "https://github.com/cafenero/homebrew-mozc-emacs-helper"
  version "0.0.3"

  depends_on "ninja"
  depends_on "python3"

  def install
    # OS version
    os_version = `sw_vers | grep ProductVersion | awk '{print $2}'`

    # SDK verson
    sdk_version=`xcrun -sdk macosx --show-sdk-version`

    # debug
    # system "cp -r ~/mozc ."
    # system "git clone https://github.com/google/mozc.git -b 2018-02-26 --single-branch --recursive"
    # system "git clone https://github.com/google/mozc.git -b 2.26.4660.102 --single-branch --recursive"
    system "git clone https://github.com/google/mozc.git -b master --single-branch --recursive"


    Dir.chdir "mozc" do
      # ea60ef4b651be0b02df4a709ad863a51b9e1ba41 : latest at 2022/08/19
      system "git checkout ea60ef4b651be0b02df4a709ad863a51b9e1ba41"

      # debug
      # system 'cp ~/mozc-emacs-helper.patch .'
      system 'curl -O https://raw.githubusercontent.com/cafenero/homebrew-mozc-emacs-helper/master/mozc-emacs-helper.patch'
      system "patch -p1 < mozc-emacs-helper.patch"

      Dir.chdir "src" do
        system "cd third_party/gyp; git apply ../../gyp/gyp.patch; cd ../../"
        system 'pip3 freeze > /tmp/hoge.txt'
        system "GYP_DEFINES='mac_sdk=#{sdk_version} mac_deployment_target=#{os_version}' python3 build_mozc.py gyp --noqt"
        system 'python3 build_mozc.py build -c Release unix/emacs/emacs.gyp:mozc_emacs_helper'
        bin.install 'out_mac/Release/mozc_emacs_helper'
      end
    end
  end
end
