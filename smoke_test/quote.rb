load File.dirname(__FILE__) +  '/../test_helper.rb'


class Quote < Test::Unit::TestCase 
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
  
# Test to create quote from company page
  def test_quote_from_company_page

      check_product

      get_Company

      getElement_xpath("company_actions").click

      getElement_text("Quote").click

      getElement_placeholder("Title").send_keys "Automation Quote "+get_Present
       
      getElement_placeholder_text("About this quote").send_keys "Created by using Automation"
      
      getElement_xpath("save").click

      wait_for_ajax(@driver)

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item

   end

   def check_company
       getElement_text("Companies").click
       getElement_text("Company name...").send_keys Keys_CONFIG["company_name_data"]
       wait(2)
       xpath = "//*[@id='main-section']/div/div[1]/div/div[2]/div/div/div/ul/li[1]/a/div"
       first_cmpny = getElement_xpath(xpath,"d").text

       status = compare(first_cmpny,Keys_CONFIG["company_name_data"])

       if(status == true)
        puts "company already created"
       else
        puts "company need to created"
        create_company
       end
   end

end
