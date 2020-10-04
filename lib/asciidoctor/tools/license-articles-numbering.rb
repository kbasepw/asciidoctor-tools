require "asciidoctor"
require "asciidoctor/tools/roman-numerals"

class LicenseArticlesNumbering < Asciidoctor::Extensions::TreeProcessor
  def process document
    return unless document.blocks?
    process_blocks document
    nil
  end

  def process_blocks node
    if node.attributes["style"] == "license"
      process_license node, "license-"
    else
      node.blocks.each do |block|
        process_blocks block if block.blocks?
      end
    end
  end

  def process_license node, base_anchor
    if node.context == :olist
      process_license_articles node, 1, base_anchor
    else
      sections = 0

      node.blocks.each do |block|
        block_anchor = base_anchor

        if block.context == :section
          sections += 1
          block_anchor += sections.to_s
          block.id = block_anchor
        end

        process_license block, block_anchor if block.blocks?
      end
    end
  end

  def process_license_articles node, level, base_anchor
    case level
    when 1
      node.style = :loweralpha
    when 2
      node.style = :arabic
    when 3
      node.style = :upperalpha
    when 4
      node.style = :lowerroman
    else
      raise "too many article levels in a license: " + level.to_s
    end

    if node.respond_to? :items
      node.items.each_with_index do |item, index|
        item.id = base_anchor + index_in_style(node.style, index)
        if item.blocks?
          item.blocks.each do |block|
            process_license_articles block, level + 1, item.id
          end
        end
      end
    end
  end

  def index_in_style style, index
    case style
    when :arabic
      (index + 1).to_s
    when :loweralpha
      (97 + index).chr
    when :upperalpha
      (65 + index).chr
    when :lowerroman
      (index + 1).to_roman.downcase
    when :upperroman
      (index + 1).to_roman
    else
      raise "unknown list format " + node.style.to_s
    end
  end
end

Asciidoctor::Extensions.register do
  treeprocessor LicenseArticlesNumbering
end

