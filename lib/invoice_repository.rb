require 'csv'
require_relative '../lib/invoice'
require_relative '../lib/create_elements'

class InvoiceRepository

  include CreateElements

  attr_reader :invoices, :engine

  def initialize(invoice_file, engine)
    @invoices = create_elements(invoice_file).map {|invoice| Invoice.new(invoice, self)}
    @engine   = engine
  end

  def find_by_id(id)
    invoices.find do |invoice|
      invoice.id == id
    end
  end

  def all
    return invoices
  end

  def count
    invoices.count
  end

  def find_all_by_customer_id(customer_id)
    invoices.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoices.find_all do |invoice|
      invoice.status == status
    end
  end

  def find_merchant(id)
    engine.merchant(id)
  end


  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

end

# find_all_by_customer_id - returns either [] or one or more matches which have a matching customer ID
# find_all_by_merchant_id - returns either [] or one or more matches which have a matching merchant ID
# find_all_by_status - returns either [] or one or more matches which have a matching status
