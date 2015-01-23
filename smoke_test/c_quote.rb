load File.dirname(__FILE__) +  '/../test_helper.rb'


class Login < Test::Unit::TestCase 
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
  def test_company_creation
      @driver.find_element(:link_text,"Companies").click

      @driver.find_element(:link_text,"Automation Company").click

      xpath = "//button[@class='button dropdown-toggle ng-scope']";

      @driver.find_element(:xpath,xpath).click

      @driver.find_element(:link_text,"Quote").click

      xpath = "//input[@placeholder='Title']";

      @driver.find_element(:xpath,xpath).send_keys "Automation Quote "+get_Present
      
      xpath = "//button[@role='button']"
      
      @driver.find_element(:xpath,xpath).click
   end

end
