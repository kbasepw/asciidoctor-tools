require "asciidoctor"
require "date"

class GitRevisionInfo < Asciidoctor::Extensions::Preprocessor
  def process document, reader
    document.attributes["revnumber"] = `git describe --tags --abbrev=0`.strip.delete "v"
    document.attributes["revdate"] = Time.at(`git log -1 --pretty="format:%at"`.to_i).utc.strftime('%Y-%m-%d')
    reader
  end
end

Asciidoctor::Extensions.register do
  preprocessor GitRevisionInfo
end

