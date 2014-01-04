class Topic

  PROPERTIES = [:id, :title, :content]
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

  def self.social(&block)
    @data = []
    BubbleWrap::HTTP.get("http://dis.dev/community/boards/social.json") do |response|
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)

        result_data.each do |result|
          @data << Topic.new(id: result["topic"]["id"], title: result["topic"]["title"], content: result["topic"]["content_raw"])
        end
        puts "MSPX Topic.music results: #{@data.length}"
      else
        App.alert("Error connecting to the DiS API: #{response.error_message} status: #{response.status_description}")
      end

      block.call(@data)
    end

  end
end