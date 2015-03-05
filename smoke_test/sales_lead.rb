load File.dirname(__FILE__) +  '/../test_helper.rb'


class Sales_Lead < Test::Unit::TestCase 
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
  
# Test to create a product 
  def test_sales_lead
      getElement_xpath("store_name").click
      mouseHover(getElement_xpath("account_settings"))
      getElement_xpath("pipeline").click
      status = check_required("pipeline_name")
      
      # creates required sales lead if not available
      if(!status)
        getElement_xpath("pipeline_new").click
        getElement_id("pipeline_name_id").send_keys Keys_CONFIG["pipeline_name"]
        getElement_id("pipeline_description_id").send_keys Keys_CONFIG["pipeline_description"]
        getElement_xpath("commit").click
        puts getElement_xpath("category_success").text
      end

      getElement_text("sales_leads").click
      getElement_text("sales_lead_new").click

      getElement_placeholder("Title").send_keys Keys_CONFIG["sales_lead_name"]
      getElement_placeholder_text("Details").send_keys Keys_CONFIG["sales_lead_description"]

      getElement_placeholder("Company Name").send_keys Keys_CONFIG["company_name_data"]

      sleep(3)
      xpath = "//ul[@class='dropdown-menu ng-isolate-scope']/li[1]/a"
      @driver.find_element(:xpath,xpath).click

      # not able to select as customer autoselect is still suggesting after selecting customer
      #getElement_placeholder("Select contact").send_keys Keys_CONFIG["company_contact_data"]

      # to select contact date
      date_select(1)

      # to select close date
      #date_select(2,1)

      getElement_xpath("pipeline_select").send_keys Keys_CONFIG["pipeline_name"]
      
      getElement_xpath("save").click
      sleep(5)
      sales_lead = getElement_xpath("company_name").text
      puts "Sales Lead name : #{sales_lead} created successfully"
   end

   def date_select(position,nxt=nil)

      xpath = Keys_CONFIG["date_custom"]+"[#{position}]"
      
      @driver.find_element(:xpath,xpath).click

      getElement_xpath("date_next").click

      # to select different date
      if(nxt!=nil)
        getElement_xpath("date_next").click        
      end

      getElement_xpath("date_select").click
   end
end
