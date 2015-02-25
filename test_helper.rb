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
Keys_CONFIG = YAML.load_file("properties.yaml")

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
    @driver.manage.timeouts.implicit_wait = 5
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver 
end

# method to login
def login
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys users(:ravi)["email"]
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys users(:ravi)["password"] 
    @driver.find_element(:name, "commit").click
end


def get_Present
    time = Time.now.strftime("%Y%m%d-%H%M%S")
end

def get_path
    path = Dir.pwd
end
#find element by xpath
def getElement_xpath(key)
    xpath = Keys_CONFIG[key]
    #puts xpath
    @driver.find_element(:xpath,xpath)
end


#find element by link text
def getElement_text(key)
  begin
    text = Keys_CONFIG[key]
    #puts text
    @driver.find_element(:link_text,text)
  rescue
    puts "Element-"+text+" not found"
    if text.eql? "Automation Company"
       create_company
       @driver.navigate.refresh
       @driver.find_element(:link_text,text)
    end
  end
end

def getElement_id(key)
    @driver.find_element(:id,Keys_CONFIG[key])
end

def getElement_class(key)
    @driver.find_element(:class,Keys_CONFIG[key])
end

#find element by place holder
def getElement_placeholder(text)
    xpath = Keys_CONFIG["placeHolder_start"]+text+Keys_CONFIG["placeHolder_end"]
   #puts xpath
    @driver.find_element(:xpath,xpath)
end
  
def getElement_placeholder_text(text)  
    xpath = Keys_CONFIG["placeHolder_start_text"]+text+Keys_CONFIG["placeHolder_end"]
    @driver.find_element(:xpath,xpath)
end
# find dropdown and select
def getSelect(key,option)
  begin
    Selenium::WebDriver::Support::Select.new(getElement_xpath(key)).select_by(:text,option)
  rescue

  end
end

# find dropdown and create option if not available
def getSelect_Add(key,create,option)
  begin
    Selenium::WebDriver::Support::Select.new(getElement_xpath(key)).select_by(:text,option)
    getElement_xpath(key).click
  rescue
    getElement_xpath(create).click

    getElement_xpath("popup_name").send_keys(option)

    getElement_xpath("popup_save").click

    wait_for_ajax(@driver)   
  end

end

# mouse hover
def mouseHover(ele)
    @driver.action.move_to(ele).perform
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

def create_company()
      time = get_Present
      getElement_text("Companies").click

      getElement_xpath("xpath").click

      getElement_text("New_company").click
      
      cmpny_Name = Keys_CONFIG["company_name_data"]
      # @driver.find_element(:xpath,xpath).send_keys "Automation Company "+time
      getElement_placeholder("Name").send_keys(cmpny_Name)

      #xpath = "div[@class='col-sm-6']/text-field/div/div/input"
      getElement_xpath("contact_name").send_keys Keys_CONFIG["company_contact_data"]
    
      getElement_xpath("contact_email").send_keys Keys_CONFIG["contact_email_data"]

      getSelect_Add("industry_select","industry_add","Automation Industry")

      getSelect_Add("source_select","source_add","Automation Source")

      getElement_xpath("save").click
end