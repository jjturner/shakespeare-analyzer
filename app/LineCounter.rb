require 'nokogiri'

class LineCounter

  def lines(doc)
    # XPath is 1-base, but Nokogiri is 0-base
    # character = doc.xpath("//SPEAKER")[0].text
    speeches = doc.xpath("//SPEECH[not(SPEAKER='ALL')]")
    prelim = speeches.inject([]) do |agg, speech|
      line_count = speech.xpath("./LINE").count
      character = speech.xpath("./SPEAKER").text
      agg << { :character => character, :line_count => line_count }
    end
    result_hash = Hash.new { |hash, key| hash[key] = 0 }

    prelim.each do |e|
      result_hash[ e[:character]] += e[:line_count]
    end
    # result_array = prelim.inject do |memo, hash| 
     #  memo.merge(hash) do |key, orig, fed| 
      #   orig + fed
    #   end
    # end
    display(result_hash) 
    result_hash
  end

  def display(hash)
    output = hash.collect {|k,v| "#{v} #{k}"}.join("\n")
  end
end
