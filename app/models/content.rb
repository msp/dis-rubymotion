class Content

  PROPERTIES = [:title, :image_id, :content]
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
    BubbleWrap::HTTP.get("http://#{API_HOST}/featured") do |response|
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)

        result_data.each do |result|
          @data << Content.new(title: result["content"]["title"], image_id: result["content"]["image_id"], content: result["content"]["content_no_html"])
        end

        puts "MSPX Content.featured results: #{@data.length}"
      else
        App.alert("Error connecting to the DiS API: #{response.error_message} status: #{response.status_description}")
      end

      block.call(@data)
    end

  end
end