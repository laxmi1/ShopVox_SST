load File.dirname(__FILE__) +  '/../test_helper.rb'


class Invoice < Test::Unit::TestCase 
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
  
# Test to create invoice from company page
  def test_invoice_creation_company_page

      check_product
      
      get_Company

      getElement_xpath("company_actions").click

      getElement_text("Invoice").click

      getElement_placeholder("Title").send_keys "Automation Invoice "+get_Present

      getElement_placeholder_text("About this invoice").send_keys "Created by using Automation"
           
      getElement_xpath("save").click

      wait_for_ajax(@driver)

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item
   end

end
