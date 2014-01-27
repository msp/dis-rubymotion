class HomeController < UIViewController

  def self.controller
    @controller ||= HomeController.alloc.initWithNibName(nil, bundle:nil)
  end

  def loadView
    views = NSBundle.mainBundle.loadNibNamed("Home", owner: self, options: nil)
    self.view = views[0]
  end

  def viewDidLoad
    super

    if App::Persistence['authToken'].nil?
      show_welcome_controller
    end

    @search = view.viewWithTag 1
    @label = view.viewWithTag 2
    @view = view.viewWithTag 3
    @featured = view.viewWithTag 4

    @search.setTitle("Loading", forState: UIControlStateDisabled)

    @search.when(UIControlEventTouchUpInside) do
      self.open_thread_controller
    end

    @view.when(UIControlEventTouchUpInside) do
      @search.enabled = false

      Topic.social do |content|
        self.open_topics_controller(content) if content.length > 0
        @search.enabled = true
      end
    end

    @featured.when(UIControlEventTouchUpInside) do
      @featured.enabled = false

      Content.featured do |content|
        self.open_featured_controller(content) if content.length > 0
        @featured.enabled = true
      end
    end
  end

  def open_topics_controller(content)
    self.navigationController.pushViewController(TopicsController.alloc.initWithContent(content), animated: true)
  end

  def open_featured_controller(content)
    self.navigationController.pushViewController(FeaturedController.alloc.initWithContent(content), animated: true)
  end

  def open_thread_controller
    self.navigationController.pushViewController(NewThreadController.alloc.init, animated: true)
  end

  def show_welcome_controller
    @welcomeController = WelcomeController.alloc.init
    @welcomeNavigationController = UINavigationController.alloc.init
    @welcomeNavigationController.pushViewController(@welcomeController, animated:false)

    HomeController.controller.presentModalViewController(@welcomeNavigationController, animated:true)
  end

end