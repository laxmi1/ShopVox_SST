load File.dirname(__FILE__) +  '/../test_helper.rb'
load File.dirname(__FILE__) +  '/../test_helper.rb'


class Login < Test::Unit::TestCase 
  fixtures :users

# To open firefox browser and the application url
  def setup
    @driver = get_driver
    @accept_next_alert = true
    @verification_errors = [] 
  end
# Throws an assertion errors
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to login with valid credentials
  def test_login_with_correct_creds
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys users(:laxmi)["email"]
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys users(:laxmi)["password"] 
    @driver.find_element(:name, "commit").click
    #assert_equal "Signed in!", @driver.find_element(:xpath, "//div[class='flash-message success']/div[2]").text
  end

# Test to login with invalid credentials
  def test_login_with_wrong_creds
    @driver.get(@base_url + "/")
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys users(:laxmi)["email"]
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys users(:laxmi)["incorrect_password"] 
    @driver.find_element(:name, "commit").click
     
    verify do
       assert_equal "E-mail or password is invalid.", @driver.find_element(:xpath, "//div[@class='error flash-message in']/div[2]").text 
    end
  end
  
# To find the element and throws an error if element is not found.
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
      rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

# To see the alert is present and throws an error if no alert is present
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
# To verify expected and actual values
# If assertion failed it throws an error
  def verify(&blk)
    yield
    rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
# To close alerts
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
    ensure
    @accept_next_alert = true
  end
end
