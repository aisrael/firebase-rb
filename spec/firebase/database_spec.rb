require 'firebase/database'

RSpec.describe Firebase::Database do
  it 'defines ServerValue::TIMESTAMP' do
    expect(defined? Firebase::Database::ServerValue::TIMESTAMP).to eq('constant')
  end
end
