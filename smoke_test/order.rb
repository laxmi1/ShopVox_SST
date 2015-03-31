load File.dirname(__FILE__) +  '/../test_helper.rb'


class Order < Test::Unit::TestCase 
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
  
# Test to create order from company page
  def test_order_creation_from_company

      check_product

      get_Company
      
      getElement_xpath("company_actions").click

      getElement_text("Order").click

      getElement_placeholder("Title").send_keys "Automation Order "+get_Present
      
      getElement_placeholder_text("About this order").send_keys "Created by using Automation"
           
      getElement_xpath("save").click

      wait_for_ajax(@driver)

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item
    end

end
