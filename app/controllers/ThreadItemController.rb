class ThreadItemController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle: nil)
    self.content = content
    self
  end

  def loadView
    views = NSBundle.mainBundle.loadNibNamed("ThreadItem", owner: self, options: nil)
    self.view = views[0]
  end


  def viewDidLoad
    super

    self.title = "DiS #{self.content.title}"

    @label = view.viewWithTag 1
    @label.text = self.content.title

    @text = view.viewWithTag 2
    @text.text = self.content.content
  end
end