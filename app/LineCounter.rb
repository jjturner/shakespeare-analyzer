require 'nokogiri'

class LineCounter
  def initialize(xml_source)
    # begin
    @doc = Nokogiri::XML(xml_source) {|config| config.strict}
    analyze_macbeth
    # rescue Nokogiri::XML::SyntaxError => e
    #   puts "caught exception #{e}"
    # end
  end

  def analyze_macbeth
    prelim = count_lines_per_speech
    result_hash = sum_lines_by_speaker(prelim)
    display(result_hash)
  end

  def count_lines_per_speech
    # XPath is 1-base, but Nokogiri is 0-base
    # character = doc.xpath("//SPEAKER")[0].text
    speeches = @doc.xpath("//SPEECH[not(SPEAKER='ALL')]")
    prelim = speeches.inject([]) do |agg, speech|
      line_count = speech.xpath("./LINE").count
      character = speech.xpath("./SPEAKER").text
      agg << { character => line_count }
    end
  end

  def sum_lines_by_speaker(hash_array)

    result_hash = Hash.new { |hash, key| hash[key] = 0 }

    hash_array.each do |e|
      e.each do |k,v|
        result_hash[k] += v
      end
    end

    return result_hash
  end

  def display(hash)
    output = hash.collect {|k,v| "#{v} #{k}"}.join("\n")
  end
end
