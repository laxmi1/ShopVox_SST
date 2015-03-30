load File.dirname(__FILE__) +  '/../test_helper.rb'


class Company < Test::Unit::TestCase 
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
  
# Test to create company from company page
  def test_company_creation_a

      puts "Company creation from company page"
      time = get_Present

      getElement_text("Companies").click

      getElement_xpath("new_customer_more").click

      getElement_text("New_company").click
      
      cmpny_Name = "Automation Company"+time

      getElement_placeholder("Name").send_keys(cmpny_Name)

      getElement_xpath("contact_name").send_keys "Automation Primary Contact"
    
      getElement_xpath("contact_email").send_keys "hari@techvoixnc.com"

      getSelect_Add("industry_select","industry_add","Automation Industry")

      getSelect_Add("source_select","source_add","Automation Source")

      #sleep(3)

      getElement_text("More_info").click

      #wait_for_ajax(@driver)
      sleep(5)
 
      getElement_text("Add_address").click

      # sleep(3)
       getSelect("address_select","Primary")
       getElement_placeholder("Street").send_keys "Street - 1"
       getElement_placeholder("Another street").send_keys "Another Street - 1"
       getElement_placeholder("City").send_keys "Auto City"
       getElement_placeholder("State").send_keys "Auto State"
       getElement_placeholder("ZIP").send_keys "4564645646".to_i
             
      getElement_placeholder("jsmith@acme.com").send_keys "support@automate.com"
      getElement_placeholder("(555) 555-5555").send_keys 9876543210
 
      getElement_placeholder_text("Background Info").send_keys "Customer created by using automation"

      getElement_placeholder_text("Other Info").send_keys "Other info added by automation"
      getElement_placeholder_text("Special Info").send_keys "Special info added by automation"
      
      #getElement_text("Less_info").click

      getElement_xpath("save").click

      sleep(5)      

      begin
        getElement_xpath("popup_ok").click
      rescue
        puts "Special Info alert not present"
      end

      puts getElement_xpath("company_name").text.to_s+" end"
   end

   def  test_company_creation_b_floatbar

      puts "Company creation for float bar"
      time = get_Present
      #mouseHover(getElement_xpath("float_add"))
      getElement_xpath("float_add").click
      
      getElement_text("New_Company").click

      cmpny_Name = "Automation Company"+time
    
      getElement_placeholder("Name").send_keys(cmpny_Name)
      
      getSelect_Add("industry_select","industry_add","Automation Industry")

      getSelect_Add("source_select","source_add","Automation Source")

      sleep(3)
        
      #xpath = "//div[@class='preloader']"
    
      #puts @driver.find_element(:xpath => xpath).displayed?

      getElement_xpath("save").click

      #wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      #wait_for_ajax(@driver)
      sleep(5)      

      #puts @driver.find_element(:xpath => xpath).displayed?
      #wait.until {! @driver.find_element(:xpath => xpath).displayed? }

      puts getElement_xpath("company_name").text.to_s+" end"

   end
end
