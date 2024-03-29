class FeaturedController < UIViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle:nil)
    self.content = content
    self
  end

  def viewDidLoad
    super

    new_frame = self.view.frame
    self.view.frame = new_frame

    self.title = "DiS Featured"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table

    @table.dataSource = self
    @table.delegate = self

  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)
    end

    cell.textLabel.text = self.content[indexPath.row].title

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
    self.navigationController.pushViewController(FeaturedItemController.alloc.initWithContent(self.content[indexPath.row]), animated: true)
  end
end