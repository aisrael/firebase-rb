require 'firebase/session'

RSpec.describe Firebase::Session do
  it 'responds ' do
    order = Order.new

    order.add_entry(LineItem.new(:item => Item.new(
                                     :price => Money.new(1.11, :USD)
                                 )))
    order.add_entry(LineItem.new(:item => Item.new(
                                     :price => Money.new(2.22, :USD),
                                     :quantity => 2
                                 )))

    expect(order.total).to eq(Money.new(5.55, :USD))
  end
end
