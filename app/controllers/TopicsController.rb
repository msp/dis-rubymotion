class TopicsController < UITableViewController

  attr_accessor :content

  def initWithContent(content)
    initWithNibName(nil, bundle: nil)
    self.content = content
    self
  end

  def viewDidLoad
    super

    self.title = "DiS Social Topics"

    tableView.addPullToRefreshWithActionHandler(
        Proc.new do
          loadData
        end
    )

  end

  def viewDidUnload
    super
  end

  def loadData

    Topic.social do |results|
      self.content = results
      view.reloadData
      tableView.pullToRefreshView.stopAnimating
    end

  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

  ## Table view data source

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    if self.content
      self.content.count
    else
      0
    end
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

=begin
  # Override to support conditional editing of the table view.
  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    # Return false if you do not want the specified item to be editable.
    true
  end
=end

=begin
  # Override to support editing the table view.
  def tableView(tableView, commitEditingStyle:editingStyle forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      # Delete the row from the data source
      tableView.deleteRowsAtIndexPaths(indexPath, withRowAnimation:UITableViewRowAnimationFade)
    elsif editingStyle == UITableViewCellEditingStyleInsert
      # Create a new instance of the appropriate class, insert it into the
      # array, and add a new row to the table view
    end
  end
=end

=begin
  # Override to support rearranging the table view.
  def tableView(tableView, moveRowAtIndexPath:fromIndexPath, toIndexPath:toIndexPath)
  end
=end

=begin
  # Override to support conditional rearranging of the table view.
  def tableView(tableView, canMoveRowAtIndexPath:indexPath)
    # Return false if you do not want the item to be re-orderable.
    true
  end
=end

  ## Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    Thread.find(self.content[indexPath.row].id) do |thread|
      self.open(thread) if thread.length > 0
    end

  end

  ## msp
  def open(thread)
    self.navigationController.pushViewController(ThreadController.alloc.initWithContent(thread), animated: true)
  end
end