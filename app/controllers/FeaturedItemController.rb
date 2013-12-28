class FeaturedItemController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle: nil)
    self.content = content
    self
  end

  def viewDidLoad
    super

    self.title = "DiS #{self.content}"
    self.view.backgroundColor = UIColor.whiteColor


    @title = UITextLabel.alloc.initWithFrame(CGRectZero)
    @title.text = self.content
    @title.sizeToFit
    @title.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview @title
  end
end