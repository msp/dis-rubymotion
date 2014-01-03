class HomeController < UIViewController

  def loadView
    views = NSBundle.mainBundle.loadNibNamed("Home", owner: self, options: nil)
    self.view = views[0]
  end

  def viewDidLoad
    super

    self.title = "DIS Forum Home"

    @search = view.viewWithTag 1
    @label = view.viewWithTag 2

    @search.setTitle("Open DiS", forState: UIControlStateNormal)
    @search.setTitle("Loading", forState: UIControlStateDisabled)

    @search.when(UIControlEventTouchUpInside) do
      @search.enabled = false

      Topic.social do |content|
        self.open_content(content) if content.length > 0
        @search.enabled = true
      end
    end
  end

  def open_content(content)
    self.navigationController.pushViewController(TopicsController.alloc.initWithContent(content), animated: true)
  end
end