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

      getElement_placeholder("Title").send_keys Keys_CONFIG["po_name"]

      getElement_placeholder_text("About this PO").send_keys Keys_CONFIG["po_about"]

      getElement_xpath("vendor_select").send_keys name
           
      getElement_xpath("save").click

      wait_for_ajax(@driver)

      puts "Transaction name "+getElement_xpath("trans_name").text

   end

   def a_test_rough
      name = Keys_CONFIG["vendor_name"]

      check_vendor(name)    
   end

   def check_vendor(name)
        vendor = name
        getElement_text("vendors").click
        getElement_placeholder("Vendor name...").send_keys vendor
        wait
        created = check_element("search_result")
        puts "created is #{created}"
        if(check_element("search_result"))
          actual = getElement_xpath("search_result").text
          status = compare(actual, vendor)
          puts "#{actual} and #{vendor}"
          if(!status)
            create_vendor(vendor)
          else
            puts "already created"
          end
        else
          create_vendor(vendor)
        end
   end

   def create_vendor(name)
      puts "Creating new Vendor with #{name}"
      getElement_text("vendors").click
      getElement_xpath("new_customer_more").click
      getElement_text("vendor_new").click
      getElement_placeholder("Name").send_keys name
      getElement_placeholder("Legal name").send_keys Keys_CONFIG["vendor_legal"]
      getElement_placeholder("Contact").send_keys Keys_CONFIG["vendor_contact"]
      getElement_placeholder_text("Background info").send_keys Keys_CONFIG["vendor_background"]
      getElement_xpath("save").click
      wait
    end
end
