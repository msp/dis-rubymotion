class APIController < UIViewController
  def viewDidLoad
    super

    self.title = "DIS API"

    self.view.backgroundColor = UIColor.whiteColor

    @search = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @search.setTitle("Search", forState: UIControlStateNormal)
    @search.setTitle("Loading", forState: UIControlStateDisabled)
    @search.sizeToFit
    @search.center = CGPointMake(self.view.frame.size.width / 2, 40)

    self.view.addSubview @search

    @search.when(UIControlEventTouchUpInside) do
      @search.enabled = false

      Content.featured do |content|
        self.open_content(content) if content.length > 0
        @search.enabled = true
      end
    end
  end

  def open_content(content)
    self.navigationController.pushViewController(FeaturedController.alloc.initWithContent(content), animated: true)
  end
end