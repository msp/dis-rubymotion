class Thread

  PROPERTIES = [:title, :content]
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

  def self.find(thread_id, &block)
    @data = []
    BubbleWrap::HTTP.get("http://dis.dev/community/boards/social/#{thread_id}.json") do |response|
      if response.ok?
        thread = BW::JSON.parse(response.body.to_str)

        @data << Thread.new(title: thread["topic"]["title"], content: thread["topic"]["content_raw"])

        thread["topic"]["comments"].each do |comment|
          @data << Thread.new(title: comment["title"], content: comment["content_raw"])
        end

        puts "MSPX Thread+Comments: #{@data.length}"
      else
        App.alert("Error connecting to the DiS API: #{response.error_message} status: #{response.status_description}")
      end

      block.call(@data)
    end

  end

  def to_s
    "#{self.title} : #{self.content}"
  end
end