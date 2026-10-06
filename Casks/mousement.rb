cask "mousement" do
  version "1.1.0"
  sha256 "07101b8f3aa21056993305241b37ce0b4fb7ec0da44b10dfa4251f04111fc50e"

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
