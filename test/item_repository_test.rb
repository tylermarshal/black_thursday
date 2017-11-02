require_relative 'test_helper'
require './lib/sales_engine'
require './lib/item_repository'
require 'pry'

class ItemRepositoryTest < MiniTest::Test

  def setup
    @sales_engine = SalesEngine.from_csv({:items => './test/fixtures/items_fixture.csv', :merchants => './test/fixtures/merchants.csv', :invoices => './test/fixtures/invoices.csv'})
    @items = @sales_engine.items
  end

  def test_it_creates_items
    assert_equal 10, @items.items.count
    assert_equal "Amy Winehouse drawing print", @items.items[0].name
    assert_equal "Sex and the city drawing print", @items.items[1].name
  end

  def test_that_it_finds_all
    assert_equal @items.items, @items.all
    assert_equal 10, @items.items.count
  end

  def test_find_by_id_nil_or_with_id_number
    assert_nil @items.find_by_id("263401670")
    assert_equal @items.items[0], @items.find_by_id("263401607")
  end

  def test_that_finds_by_name
    assert_nil @items.find_by_name("Trampoline")
    assert_equal @items.items[4], @items.find_by_name("Black Jorts")
  end

  def test_that_it_matches_items_with_similar_description
    assert_equal ([]), @items.find_all_with_description("meow")

    item1 = @items.items[2]
    item2 = @items.items[9]
    result = [item1, item2]

    assert_equal result, @items.find_all_with_description("unbelievably")
    assert_equal result, @items.find_all_with_description("nbElIeVaBly")
  end

  def test_that_it_matches_items_with_similar_merch_id
    item1 = @items.items[0]
    item2 = @items.items[1]
    item3 = @items.items[2]
    result = [item1, item2, item3]

    assert_equal ([]), @items.find_all_by_merchant_id("263401607")
    assert_equal result, @items.find_all_by_merchant_id("12334112")
  end

  def test_that_it_finds_all_items_by_price
    item1 = @items.items[4]
    item2 = @items.items[6]
    result = [item1, item2]

    assert_equal ([]), @items.find_all_by_price(9999)
    assert_equal result, @items.find_all_by_price(3000)
  end

  def test_that_it_finds_all_items_by_price_in_range
    item1 = @items.items[3]
    item2 = @items.items[5]
    result = [item1, item2]

    assert_equal ([]), @items.find_all_by_price_in_range(9999,10235)
    assert_equal result, @items.find_all_by_price_in_range(4500, 4995)
  end
  #
  #
end
