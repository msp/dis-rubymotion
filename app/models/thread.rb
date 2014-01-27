class Thread

  API_TOPICS_CREATE_ENDPOINT = "http://#{API_HOST}/topics.json"

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

  def to_s
    "#{self.title} : #{self.content}"
  end


  def self.find(thread_id, &block)
    @data = []
    BubbleWrap::HTTP.get("http://#{API_HOST}/community/boards/social/#{thread_id}.json") do |response|
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

  def self.create(params = {}, &block)
    params[:user_credentials] = App::Persistence['authToken']
    params[:section_id] = 23 #TODO social only
    data = BW::JSON.generate(params)

    BW::HTTP.post(API_TOPICS_CREATE_ENDPOINT, { headers: Thread.headers, payload: data } ) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_str)
          block.call(json)
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Topic creation failed: #{response.error_message} status: #{response.status_description}")
        else
          App.alert(response.to_str)
        end
      end
    end
  end

  def self.headers
    {
        'Content-Type' => 'application/json'
    }
  end

end