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
def getElement_xpath(key,d=nil)
    if(d==nil)
      xpath = Keys_CONFIG[key]
      begin
        @driver.find_element(:xpath,xpath)
      rescue
        puts "Element : "+xpath+" not found"
      end  
    elsif(d!=nil)
      @driver.find_element(:xpath,key)
    end
end

def check_element(key,d=nil)
  status = false
  begin
    @driver.find_element(:xpath,Keys_CONFIG[key])
    status = true
  rescue
    status = false
  end
  status
end

#find element by link text by using keys
def getElement_text(key)
  begin
    text = Keys_CONFIG[key]
    #puts text
    @driver.find_element(:link_text,text)
  rescue
    puts "Element -"+text+" not found"
    if text.eql? "Automation Company"
       create_company
       @driver.navigate.refresh
       @driver.find_element(:link_text,text)
    end
  end
end
  
#find element by link text direct
def getElement_text_direct(key)
  begin
    @driver.find_element(:link_text,key)
  rescue
    puts "Text - "+key+" not found"
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
  
# find element by tagname textarea 
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
    #begin
      #@driver.action.move_to(ele).perform
    #rescue
      ele.click
    #end
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
      #getElement_text("Companies").click
      #getElement_text("Customers").click   
      wait
      getElement_xpath("new_customer_more").click
      getElement_text("New_company").click
      
      cmpny_Name = Keys_CONFIG["company_name_data"]

      getElement_placeholder("Name").send_keys(cmpny_Name)

      getElement_xpath("contact_name").send_keys Keys_CONFIG["company_contact_data"]
    
      getElement_xpath("contact_email").send_keys Keys_CONFIG["contact_email_data"]

      getSelect_Add("industry_select","industry_add","Automation Industry")

      getSelect_Add("source_select","source_add","Automation Source")

      getElement_xpath("save").click
end

def check_product(name=nil)
      go_to_products
      @prd_name = Keys_CONFIG["product_name"]
      if(name!=nil)
        @prd_name = Keys_CONFIG["product_name"]+name
      end
      getElement_id("product_count_search").send_keys @prd_name
      sleep(3)
      puts getElement_id("product_count_id").text 
      xpath = Keys_CONFIG["product_after_search"]
      begin
          @driver.find_element(:xpath,xpath)
          puts "Product already created"    
      rescue
        puts "Product to be created"
        if(name!=nil)
          add_Product(name)
        else
          add_Product
        end
      end
end

# add a product by creating new product type and category
def add_Product(name=nil)
    
    if(name !=nil)
      puts "inside not null"
      add_Product_Type(name)
      go_to_products
      add_Product_Category(name)

    else
      puts "inside else"
      add_Product_Type
      go_to_products
      add_Product_Category
    end

    go_to_products

    @product_name = Keys_CONFIG["product_name"]
    @product_type = Keys_CONFIG["product_type_name"]
    @product_category = Keys_CONFIG["product_category_name"]

    # to take option name
    if(name!=nil)
      @product_name = Keys_CONFIG["product_name"]+name
      @product_type = Keys_CONFIG["product_type_name"] + name
      @product_category = Keys_CONFIG["product_category_name"]+name
    end
    getElement_text("product_new").click
    getElement_id("product_name_id").send_keys @product_name
    getElement_id("product_description_id").send_keys "created by using automation"
     

    getElement_id("product_type_id").send_keys @product_type
    sleep(3)
    
    # to take away focus
    getElement_id("product_cost_in_dollars_id").clear
    getElement_id("product_cost_in_dollars_id").send_keys "30"
    sleep(5)

    getElement_id("product_category_id").send_keys @product_category
    sleep(3)
    getElement_id("product_sub_category_id").send_keys Keys_CONFIG["product_category_name"]
    getElement_id("product_income_coa_account_id").send_keys "Accounts Receivable - 1200"
    getElement_id("product_cog_coa_account_id").send_keys "Cost of Materials - 5100"

    getElement_id("product_price_in_dollars_id").clear
    getElement_id("product_price_in_dollars_id").send_keys "50"   

    getElement_id("product_part_number_id").send_keys "Automate-1243"
    getElement_id("product_production_details_id").send_keys "Automation Production Details"
    getElement_id("product_other_info_id").send_keys "Automation Other Info Details"
    getElement_xpath("commit").click

    puts  getElement_xpath("category_success").text
end

def go_to_products
    getElement_xpath("store_name").click
    mouseHover(getElement_xpath("pos_settings"))
    sleep(2)
    mouseHover(getElement_xpath("pricing"))
    sleep(2)
    getElement_xpath("products").click    
end


def add_Product_Type(name=nil)
    getElement_text("product_type").click
    getElement_text("new_product_type_text").click
    if (name!=nil)
      @prd_type_name = Keys_CONFIG["product_type_name"] + name
    else
      @prd_type_name = Keys_CONFIG["product_type_name"]
    end
    getElement_id("category_name_id").send_keys @prd_type_name
    getElement_xpath("commit").click
    puts  getElement_xpath("category_success").text
end

def add_Product_Category(name=nil)
    getElement_text("product_category").click
    getElement_text("new_product_category_text").click
    @prd_cat_name = Keys_CONFIG["product_category_name"]
    @prd_type_name= Keys_CONFIG["product_type_name"]
    if(name!=nil)
      @prd_cat_name = Keys_CONFIG["product_category_name"]+name
      @prd_type_name= Keys_CONFIG["product_type_name"]+name
    end
    getElement_id("category_name_id").send_keys @prd_cat_name
    getElement_id("product_sub_type").send_keys @prd_type_name
    getElement_xpath("commit").click
    puts  getElement_xpath("category_success").text
end

# method to add a product as a line item
def add_line_item(name=nil)
      
      getElement_xpath("add_line_item").click

      sleep(5)

      getElement_xpath("product_name_search").click

      product_name = Keys_CONFIG["product_name"]
      if(name!=nil)
        product_name = Keys_CONFIG["product_name"]+name
      end

      getElement_placeholder("Search for product...").send_keys product_name

      sleep(2)

      getElement_xpath("item_first").click

      sleep(3)

      getElement_xpath("popup_save").click

      sleep(5)
   end

   def check_required(key,name=nil)
      @status = true
      @req_name = Keys_CONFIG[key]
      if(name!=nil)
        @req_name = Keys_CONFIG[key]+name
      end
      getElement_id("product_count_search").send_keys @req_name
      sleep(3)
      puts getElement_id("product_count_id").text 
      xpath = Keys_CONFIG["product_after_search"]
      begin
          @driver.find_element(:xpath,xpath)
          puts "Required already created"    
      rescue
        puts "Required need to be created"
        @status = false
      end
      @status
    end

    # method to compare two variables
    def compare(val1,val2)
        status = false
        if(val1.eql?val2)
          status = true
        end
        status
    end

    def wait(time=nil)
      wt =5
        if(time!=nil)
          wt = time
        end
        sleep(wt)
    end

    # method to open required company
    def get_Company(name=nil)

      getElement_text("cust_vendors").click

      getElement_text("Customers").click

      if(name!=nil)
        getElement_text_direct(name).click
      else
        getElement_text("company_name_data").click
      end
    end

    # method to open vendors
    def get_Vendor
        getElement_text("cust_vendors").click
        getElement_text("vendors").click
    end

    def check_vendor(name)
        vendor = name
        get_Vendor
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
      get_Vendor
      getElement_xpath("new_customer_more").click
      getElement_text("vendor_new").click
      getElement_placeholder("Name").send_keys name
      getElement_placeholder("Legal name").send_keys Keys_CONFIG["vendor_legal"]
      getElement_placeholder("Contact").send_keys Keys_CONFIG["vendor_contact"]
      getElement_placeholder_text("Background info").send_keys Keys_CONFIG["vendor_background"]
      getElement_xpath("save").click
      wait
    end