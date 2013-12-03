class Content

  PROPERTIES = [:title]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

  def self.featured(&block)
    @data = []
    BubbleWrap::HTTP.get("http://dis.dev/featured") do |response|
      #TODO No data or 500/404?
      result_data = BW::JSON.parse(response.body.to_str)

      result_data.each do |result|
        @data << result["content"]["title"]
      end

      puts "MSPX Content.featured results: #{@data.length}"
      block.call(@data)
    end

  end
end