cask "mousement" do
  version "1.0.0"
  sha256 "a8502f02d3d0a16ffc19e4cb4bc40c84b81a0f7087ea58d0cc38a4e86168a027"

  url "https://github.com/zenmz/mousement/releases/download/v#{version}/Mousement.zip"
  name "Mousement"
  desc "Natural background mouse movement simulator to prevent idle status"
  homepage "https://github.com/zenmz/mousement"

  app "Mousement.app"

  postflight do
    system_command "xattr",
                   args: ["-cr", "#{appdir}/Mousement.app"]
  end

  uninstall quit: "com.zen.Mousement"
end
