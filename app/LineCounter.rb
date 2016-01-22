require 'nokogiri'

class LineCounter

  def lines(doc)
    # XPath is 1-base, but Nokogiri is 0-base
    character = doc.xpath("//SPEAKER")[0].text
    line_count = doc.xpath("//SPEECH").children.count - 1
    "%d %s" % [line_count, character]
  end
end
