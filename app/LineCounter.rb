require 'nokogiri'

class LineCounter

  def lines(doc)
    # XPath is 1-base, but Nokogiri is 0-base
    character = doc.xpath("//SPEAKER")[0].text
    speech_count = doc.xpath("//SPEECH").count
    line_count = doc.xpath("//SPEECH").children.count - speech_count
    "%d %s" % [line_count, character]
  end
end
