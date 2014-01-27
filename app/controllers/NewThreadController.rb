class NewThreadController < Formotion::FormController
  def init
    form = Formotion::Form.new({
                                   sections: [{
                                                  rows: [{
                                                             title: "Title",
                                                             key: :title,
                                                             placeholder: "Topic title",
                                                             type: :string,
                                                             auto_correction: :yes,
                                                             auto_capitalization: :none
                                                         }, {
                                                              title: "Body",
                                                              key: :content,
                                                              placeholder: "Topic body",
                                                              type: :string,
                                                              auto_correction: :yes,
                                                              auto_capitalization: :none
                                                  }],
                                              }, {
                                                  rows: [{
                                                             title: "Save",
                                                             type: :submit,
                                                         }]
                                              }]
                               })
    form.on_submit do
      self.createTopic
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super

    self.title = "New Topic"

    cancelButton = UIBarButtonItem.alloc.initWithTitle("Cancel",
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:'cancel')
    self.navigationItem.rightBarButtonItem = cancelButton
  end

  def createTopic
    title = form.render[:title]
    content = form.render[:content]
    if title.strip == ""
      App.alert("Please enter a title for the topic")
    else
      taskParams = { topic: { title: title, content_raw: content } }

      #SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
      Thread.create(taskParams) do |json|
        App.alert(json['info'])
        self.navigationController.dismissModalViewControllerAnimated(true)
        #TasksListController.controller.refresh

        # TODO return this from POST instead of issue another GET
        Topic.social do |content|
          self.navigationController.pushViewController(TopicsController.alloc.initWithContent(content), animated: true)
        end

        #SVProgressHUD.dismiss
      end
    end
  end

  def cancel
    self.navigationController.dismissModalViewControllerAnimated(true)

    Topic.social do |content|
      self.navigationController.pushViewController(TopicsController.alloc.initWithContent(content), animated: true)
    end

  end
end