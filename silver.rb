# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Silver < Formula
  desc "reproduce the system"
  homepage "https://github.com/kijimaD/silver"
  version "1.4.1"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/kijimaD/silver/releases/download/v1.4.1/silver_Darwin_x86_64.tar.gz"
      sha256 "fe6a015602d839242332120e5122780dd9918c62aafaa7034d30c27f74a0122f"

      def install
        bin.install "silver"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/kijimaD/silver/releases/download/v1.4.1/silver_Darwin_arm64.tar.gz"
      sha256 "2d0a6d20d246fbbc673255644d514944d41ab7b261efd2dbb3fdf0bc2d7a174a"

      def install
        bin.install "silver"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/kijimaD/silver/releases/download/v1.4.1/silver_Linux_arm64.tar.gz"
      sha256 "69375d9dd5af8c408b559bf90a29a67d778a9342b2e65d74f6ada8bb682a5fdd"

      def install
        bin.install "silver"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/kijimaD/silver/releases/download/v1.4.1/silver_Linux_x86_64.tar.gz"
      sha256 "41a1741ffefede5527bdee29cf09e7e3cef1cf0f4d1ebe86460ccab2e25f85c7"

      def install
        bin.install "silver"
      end
    end
  end
end