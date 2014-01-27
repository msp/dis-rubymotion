class FeaturedItemController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle: nil)
    self.content = content
    self
  end

  def loadView
    views = NSBundle.mainBundle.loadNibNamed("FeaturedItem", owner: self, options: nil)
    self.view = views[0]
  end


  def viewDidLoad
    super

    self.title = self.content.title

    @image = view.viewWithTag 1
    @text = view.viewWithTag 2

    @text.text = content.content
    image_url = "http://dis.images.s3.amazonaws.com/#{content.image_id}.jpeg"

    BW::HTTP.get(image_url) do |response|
      if response.ok?
        @image.image = UIImage.alloc.initWithData(response.body)
      else
        puts("Error getting image: #{response.error_message} status: #{response.status_description} url: #{image_url}")
      end
    end
  end
end