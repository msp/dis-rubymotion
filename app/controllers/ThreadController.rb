class ThreadController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle: nil)
    self.content = content
    self
  end

  def viewDidLoad
    super

    self.title = "DiS #{self.content[0].title}" if self.content.length > 0

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
      self.content.length
    else
      0
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.open(self.content[indexPath.row])
  end

  def open(thread)
    self.navigationController.pushViewController(ThreadItemController.alloc.initWithContent(thread), animated: true)
  end

end