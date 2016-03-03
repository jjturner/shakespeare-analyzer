require 'nokogiri'
require 'open-uri'

class LineCounter
  def initialize(xml_source, source_type="local")
    # begin
    if source_type == "html"
      @doc = Nokogiri::XML(open(xml_source)) {|config| config.strict}
    else
      @doc = Nokogiri::XML(xml_source) {|config| config.strict}
    end
    analyze_macbeth
    # rescue Nokogiri::XML::SyntaxError => e
    #   puts "caught exception #{e}"
    # end
  end

  def analyze_macbeth
    list = sum_lines_by_speaker
    # result_hash = sum_lines_by_speaker(prelim)
    puts display(list)
  end

  def sum_lines_by_speaker
    # XPath is 1-base, but Nokogiri is 0-base
    # character = doc.xpath("//SPEAKER")[0].text
    speeches = @doc.xpath("//SPEECH[not(SPEAKER='ALL')]")
    list = speeches.inject(Hash.new(0)) do |agg, speech|
      character = speech.xpath("./SPEAKER").text.to_s
      lines = speech.xpath("./LINE")
      lines.each do |line|
        agg[character] += 1 
      end
      agg
    end
  end

#  def sum_lines_by_speaker(hash_array)
#
#    result_hash = Hash.new { |hash, key| hash[key] = 0 }
#
#    hash_array.each do |e|
#      e.each do |k,v|
#        result_hash[k] += v
#      end
#    end
#
#    return result_hash
#  end

  def display(hash)
    output = hash.sort_by{|k,v|-v}.collect {|k,v| "#{v} #{k}"}.join("\n")
  end
end
