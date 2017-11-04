module MerchantAnalyst

  def average_items_per_merchant
    (total_items/total_merchants).round(2)
  end

  def average_items_per_merchant_standard_deviation
    calculate_std_dev
  end

  def find_items_per_merchant
    pull_all_merchant_ids.map do |merchant_id|
      @sales_engine.items.find_all_by_merchant_id(merchant_id).count
    end
  end

  def calculate_std_dev
    sum = find_items_per_merchant.reduce(0) do |result, merchant|
      squared_difference = (average_items_per_merchant - merchant) ** 2
      result + squared_difference
    end
    Math.sqrt(sum / (total_merchants-1)).round(2)
  end

  def merchants_and_item_count
    Hash[pull_all_merchant_ids.zip find_items_per_merchant]
  end

  def merchants_with_high_item_count
    high_item_count_merchant_ids.map do |merchant_id|
      @sales_engine.merchants.find_by_id(merchant_id)
    end
  end

  def high_item_count_merchant_ids
    merchants_and_item_count.map do |merchant_id,item_count|
      merchant_id if item_count > (average_items_per_merchant + calculate_std_dev)
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    item_prices = @sales_engine.items.items.map do |item|
      item.unit_price if item.merchant_id == merchant_id
    end.compact
    (item_prices.sum/item_prices.length).round(2)
  end

  def average_average_price_per_merchant
    average_price = @sales_engine.merchants.all.reduce(0) do |result,merchant|
      result += average_item_price_for_merchant(merchant.id)
    end/total_merchants
    average_price.round(2)
  end

end