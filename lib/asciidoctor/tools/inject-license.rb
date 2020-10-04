require "asciidoctor"

class InjectLicenseFooter < Asciidoctor::Extensions::Preprocessor
  def process document, reader
    Asciidoctor::Reader.new reader.readlines + [""] + %w[
      ---
      image:https://i.creativecommons.org/l/by/4.0/88x31.png[link=http://creativecommons.org/licenses/by/4.0/,title=Creative Commons License]
      This work is licensed under a
      link:http://creativecommons.org/licenses/by/4.0/[Creative Commons Attribution 4.0 International License]
    ]
  end
end

Asciidoctor::Extensions.register do
  preprocessor InjectLicenseFooter
end

