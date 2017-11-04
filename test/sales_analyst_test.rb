require_relative 'test_helper'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'

class SalesAnalystTest < Minitest::Test

  def setup
    sales_engine = SalesEngine.from_csv({:items => './test/fixtures/items_fixture.csv',
                                        :merchants => './test/fixtures/merchants.csv',
                                        :invoices => './test/fixtures/invoices.csv',
                                        :invoice_items => './test/fixtures/invoice_items.csv'})
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_that_we_find_average_items_per_merchant
    assert_equal 0.83, @sales_analyst.average_items_per_merchant
  end

  def test_it_can_find_standard_deviation
    assert_equal 1.06, @sales_analyst.average_items_per_merchant_standard_deviation
  end

  def test_it_can_find_merchants_with_high_item_count
    assert_equal ["Candis--art", "Motanki--Darena", "byMariein--London"], @sales_analyst.merchants_with_high_item_count
  end

  def test_it_can_determine_average_price_for_merchant
    assert_equal 48.33, @sales_analyst.average_item_price_for_merchant(12334112)
  end

  def test_it_can_determine_average_price_per_merchant
    assert_equal 147.50, @sales_analyst.average_average_price_per_merchant
  end
end
