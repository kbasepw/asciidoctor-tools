require "asciidoctor"

class HighlightTodos < Asciidoctor::Extensions::Preprocessor
  @@TAGS = [
    "TODO:",
    "FIXME:",
    "BUG:"
  ]

  def process document, reader
    Asciidoctor::Reader.new (reader.readlines.map do |line|
      tag = @@TAGS.find {|t| line.start_with? t}
      if tag
        [
          "****",
          %(*#{tag}* #{line[(tag.length)..].strip}),
          "****"
        ]
      else
        line
      end
    end).flatten
  end
end

Asciidoctor::Extensions.register do
  preprocessor HighlightTodos
end

