require_relative 'test_helper'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice_repository'
require 'pry'

class InvoiceRepositoryTest < MiniTest::Test

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items => './test/fixtures/items_fixture.csv',
      :merchants => './test/fixtures/merchants.csv',
      :invoices => './test/fixtures/invoices.csv',
      :invoice_items => './test/fixtures/invoice_items.csv'})
    @invoices = @sales_engine.invoices
    @merchants = @sales_engine.merchants
  end

  def test_that_invoices_are_created
    assert_equal 49, @invoices.count
    assert_equal 1, @invoices.invoices[0].id
    assert_equal 2, @invoices.invoices[1].id
  end

  def test_that_it_finds_all_invoices
    assert_equal @invoices.invoices, @invoices.all
  end

  def test_that_it_finds_invoices_by_id
    invoice1 = @invoices.invoices[0]

    assert_equal invoice1, @invoices.find_by_id(1)
  end

  def test_that_it_finds_all_by_customer_id
    invoice1 = @invoices.invoices[12]
    invoice2 = @invoices.invoices[13]
    invoice3 = @invoices.invoices[14]

    assert_equal ([]), @invoices.find_all_by_customer_id(100)
    assert_equal [invoice1, invoice2, invoice3],
                  @invoices.find_all_by_customer_id(3)
  end

  def test_that_it_finds_all_by_merchant_id
    invoice1 = @invoices.invoices[2]
    invoice2 = @invoices.invoices[7]
    invoice3 = @invoices.invoices[8]
    invoice4 = @invoices.invoices[9]
    invoice5 = @invoices.invoices[45]

    assert_equal ([]), @invoices.find_all_by_merchant_id(100)
    assert_equal [invoice1, invoice2,
                  invoice3, invoice4,
                  invoice5],
                  @invoices.find_all_by_merchant_id(12334155)
  end

  def test_that_it_finds_all_by_status
    invoice1 = @invoices.invoices[18]
    invoice2 = @invoices.invoices[23]
    invoice3 = @invoices.invoices[27]
    invoice4 = @invoices.invoices[33]
    invoice5 = @invoices.invoices[37]
    invoice6 = @invoices.invoices[44]
    invoice7 = @invoices.invoices[47]
    invoice8 = @invoices.invoices[48]
    result = [invoice1, invoice2, invoice3,
              invoice4, invoice5, invoice6,
              invoice7, invoice8]

    assert_equal ([]), @invoices.find_all_by_status(:return)
    assert_equal result, @invoices.find_all_by_status(:returned)
  end

  def test_that_it_finds_merchant_by_invoice_id
    merchant1 = @merchants.all[0]

    assert_equal merchant1, @invoices.find_merchant(12334112)
  end

end
