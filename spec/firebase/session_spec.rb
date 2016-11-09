require 'firebase'

TEST_CREDENTIALS = File.expand_path('../../test-credentials.json', __FILE__)

RSpec.describe Firebase::Session do

  it 'responds to #app' do
    firebase = Firebase.initialize_app database_url: 'https://penapple-18501.firebaseio.com/',
                                       service_account: TEST_CREDENTIALS

    session = Firebase::Session.new(firebase)
    expect(session).to respond_to(:app)
    expect(session.app).to be(firebase)
  end

end
