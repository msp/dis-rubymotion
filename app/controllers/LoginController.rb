class LoginController < Formotion::FormController

  # curl --data "user_session[username]=polymorphic2&user_session[password]=xxxx" http://dis.dev/sessions/create.json?

  API_LOGIN_ENDPOINT = "http://#{API_HOST}/sessions/create.json"

  def init
    form = Formotion::Form.new({
                                   sections: [{
                                                  rows: [{
                                                             title: "Username",
                                                             key: :username,
                                                             placeholder: "dis_user",
                                                             type: :string,
                                                             auto_correction: :no,
                                                             auto_capitalization: :none
                                                         }, {
                                                             title: "Password",
                                                             key: :password,
                                                             placeholder: "required",
                                                             type: :string,
                                                             secure: true
                                                         }],
                                              }, {
                                                  rows: [{
                                                             title: "Login",
                                                             type: :submit,
                                                         }]
                                              }]
                               })
    form.on_submit do
      self.login
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super

    self.title = "Login"
  end

  def login
    headers = {'Content-Type' => 'application/json'}
    data = BW::JSON.generate({user_session: {
        username: form.render[:username],
        password: form.render[:password]
    }})

    #SVProgressHUD.showWithStatus("Logging in", maskType: SVProgressHUDMaskTypeGradient)
    BW::HTTP.post(API_LOGIN_ENDPOINT, {headers: headers, payload: data}) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_str)
          App::Persistence['authToken'] = json['data']['auth_token']
          App.alert(json['info'])
          self.navigationController.dismissModalViewControllerAnimated(true)
          #TasksListController.controller.refresh
        elsif response.status_code.to_s =~ /4\d\d/
          App.alert("Login failed: #{response.error_message} status: #{response.status_description}")
        elsif response.status_code.to_s =~ /5\d\d/
          App.alert("Server error: please try again: #{response.error_message} status: #{response.status_description}")
        else
          App.alert("Something went bad. Very bad.")
        end
      end
      #SVProgressHUD.dismiss
    end
  end
end