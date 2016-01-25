require 'nokogiri'

class LineCounter

  def lines(doc)
    # XPath is 1-base, but Nokogiri is 0-base
    # character = doc.xpath("//SPEAKER")[0].text
    speeches = doc.xpath("//SPEECH[not(SPEAKER='ALL')]")
    prelim = speeches.inject([]) do |agg, speech|
      line_count = speech.xpath("./LINE").count
      character = speech.xpath("./SPEAKER").text
      agg << { character => line_count }
    end
    prelim.inject do |memo, hash| 
      memo.merge(hash) do |key, orig, fed| 
        orig + fed
      end
    end

  end
end
