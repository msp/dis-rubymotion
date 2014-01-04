class TopicsController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle:nil)
    self.content = content
    self
  end

  def viewDidLoad
    super

    self.title = "DiS Social Topics"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table

    @table.dataSource = self
    @table.delegate = self

  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @reuseIdentifier)
    end

    cell.textLabel.text = self.content[indexPath.row].title
    cell.detailTextLabel.text = self.content[indexPath.row].content

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    if self.content
      self.content.count
    else
      0
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    Thread.find(self.content[indexPath.row].id) do |thread|
      self.open(thread) if thread.length > 0
    end

  end

  def open(thread)
    self.navigationController.pushViewController(ThreadController.alloc.initWithContent(thread), animated: true)
  end
end