load File.dirname(__FILE__) +  '/../test_helper.rb'


class Purchase_Order < Test::Unit::TestCase 
  fixtures :users

#To open firefox browser and the application url
  def setup
    @driver = get_driver
    login
    @accept_next_alert = true
    @verification_errors = [] 
  end
# Throws an assertion errors
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to create purchase order from transactions
  def test_purchase_order
       
      name = Keys_CONFIG["vendor_name"] 

      check_vendor(name)

      getElement_text("transactions").click

      getElement_text("purchase_orders").click

      getElement_xpath("new_po").click

      po_name = Keys_CONFIG["po_name"]+" "+get_Present

      getElement_placeholder("Title").send_keys po_name

      getElement_placeholder_text("About this PO").send_keys Keys_CONFIG["po_about"]

      getElement_xpath("vendor_select").send_keys name
           
      getElement_xpath("save").click

      #wait_for_ajax(@driver)
      wait

      puts "Transaction name "+getElement_xpath("trans_name").text

   end

end
