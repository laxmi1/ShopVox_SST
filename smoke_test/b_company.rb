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
  
# Test to create company from company page
  def test_company_creation
      time = Time.now.strftime("%Y%m%d-%H%M%S")

      @driver.find_element(:link_text,"Companies").click

      xpath = "//button[@class='button transparent dropdown-toggle ng-scope']"
      @driver.find_element(:xpath,xpath).click
      @driver.find_element(:link_text,"New company").click

      xpath = "//input[@placeholder='Name']";
      @driver.find_element(:xpath,xpath).send_keys "Automation Company "+time

      xpath = "//vox-select-field[contains(@options,'industries')]/div/select"
      select = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath,xpath))
      select.select_by(:text,"Manufacturing Company")

      xpath = "//vox-select-field[contains(@options,'leadSources')]/div/select"
      select = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath,xpath))
      select.select_by(:text,"Google")

      xpath = "//button[@role='button']"
      @driver.find_element(:xpath,xpath).click
   end

end
