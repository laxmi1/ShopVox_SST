require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require 'rubygems'
require 'time'
#require "active_support"
#gem 'minitest'
#require 'minitest'
#require 'turn/autorun'

#Minitest.autorun
require 'yaml'

#Time.zone = "Pacific Time (US & Canada)"
APPLICATION_CONFIG = YAML.load_file("config.yaml")

# Fixtures support
class Test::Unit::TestCase 
  @@fixtures = {}
  @@config = {}
  def self.fixtures list
    [list].flatten.each do |fixture|
      self.class_eval do
        # add a method name for this fixture type
        define_method(fixture) do |item|
          # load and cache the YAML
          @@fixtures[fixture] ||= YAML::load_file("fixtures/#{fixture.to_s}.yaml")
          @@fixtures[fixture][item.to_s]
        end
      end
    end
  end
end

def element_present?(how, what)
      @driver.find_element(how, what)
      true
        rescue Selenium::WebDriver::Error::NoSuchElementError
      false
end

def alert_present?()
      @driver.switch_to.alert
      true
        rescue Selenium::WebDriver::Error::NoAlertPresentError
      false
end

def verify(&blk)
      yield
      rescue Test::Unit::AssertionFailedError => ex
      @verification_errors << ex
end

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

# get webdriver object
def get_driver
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = Dir.pwd+"/downloads"
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/octet-stream,application/pdf"
    profile['pdfjs.disabled'] = true
    profile['pdfjs.firstRun'] = false
    @driver= Selenium::WebDriver.for :firefox, :profile => profile
    @base_url = APPLICATION_CONFIG["base_url"] 
    @admin_url = APPLICATION_CONFIG["admin_url"] 
    @new_account_url = APPLICATION_CONFIG["new_account_url"]
    @driver.manage.timeouts.implicit_wait = 30
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver 
end

def login
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys users(:laxmi)["email"]
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys users(:laxmi)["password"] 
    @driver.find_element(:name, "commit").click
end

def get_Present
    time = Time.now.strftime("%Y%m%d-%H%M%S")
end
def wait_for_ajax(driver)
   wait = Selenium::WebDriver::Wait.new(:timeout => 30)
   wait.until { driver.execute_script("return jQuery.active == 0") } 
end

def check_and_accept_alert(driver)
  driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
end

def check(state, element_id)
  element=@driver.find_element(:id, element_id)
  if element.selected? != state
    element.click
  end
end

def loadtime(time)
    @driver.manage.timeouts.implicit_wait = time
end
