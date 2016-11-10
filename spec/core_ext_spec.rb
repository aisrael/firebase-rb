require 'core_ext'

RSpec.describe HashExtensions do

  describe 'camelize_keys!' do

    it 'camelizes keys' do
      hash = {
        user_id: 'user1',
        created_at: Time.now
      }
      hash.camelize_keys!
      expect(hash.keys).to eq([:userId, :createdAt])
    end

    it 'works deeply' do
      deep = {
        total_count: 1,
        users: [
          {
            user_id: 'user1'
          }
        ]
      }
      deep.camelize_keys!
      expect(deep).to eq({
        totalCount: 1,
        users: [
          {
            userId: 'user1'
          }
        ]
      })
    end
  end

end
