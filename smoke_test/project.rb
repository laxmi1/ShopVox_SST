load File.dirname(__FILE__) +  '/../test_helper.rb'


class Project < Test::Unit::TestCase 
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
    #@driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to create project
  def test_project

      # check_company

      #getElement_text("Companies").click

      #getElement_text("company_name_data").click

      getElement_text("project").click

      wait

      getElement_xpath("project_new").click

      wait

      getElement_xpath("customer_click").click
      company_name = Keys_CONFIG["company_name_data"]
      
      pro_name = Keys_CONFIG["project_name"]+" "+get_Present

      getElement_xpath("customer_type").send_keys company_name
      wait
      getElement_xpath("customer_select").click
      
      getElement_placeholder("Name").send_keys pro_name
      
      getElement_placeholder_text("About this Project").send_keys Keys_CONFIG["project_description"]

      getElement_xpath("project_lead_source").send_keys Keys_CONFIG["project_lead_source_option"]      
      
      getElement_xpath("due_date").click

      getElement_xpath("date_next").click

      getElement_xpath("date_select").click

      #getElement_xpath("sale_date").click

      #getElement_xpath("date_next").click

      #getElement_xpath("date_select").click

      getElement_xpath("sales_rep").send_keys "Ravi"
      getElement_xpath("production_manager").send_keys "Ravi"
      getElement_xpath("project_manager").send_keys "Ravi"
      
      getElement_xpath("record_payment").click   

      wait

      getElement_placeholder("Search...").send_keys pro_name

      wait

      begin 
        actual = getElement_xpath("project_table").text
        status = compare(actual,pro_name)
        if(status)
          puts "Project created successfully"
          @driver.find_element(:link_text,pro_name).click
          wait
          getElement_xpath("quote_more").click
          
          add_quote
          
          get_project(pro_name)

          #add_order

        else
          puts "Project not created"
        end
      rescue
        puts "Project not created"
      end
   end

   def get_project(project_name)
      getElement_text("project").click
      @driver.find_element(:link_text,project_name).click
      wait
   end

   def add_quote

      getElement_text("project_quote").click

      getElement_placeholder("Title").send_keys "Automation Quote "+get_Present
       
      getElement_placeholder_text("About").send_keys "Created by using Automation"
      
      getElement_xpath("record_payment").click
    
      wait

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item
   end

   def add_order
      @driver.get("http://localhost:3000/87498d82-efdb-4c04-b410-361491e34595/dashboard#/projects/bd8bd75f-05a9-4e64-9212-1ab890845106")
      wait
      getElement_xpath("quote_more").click

      getElement_text("project_order").click

      getElement_placeholder("Title").send_keys "Automation Order "+get_Present
       
      getElement_placeholder_text("About").send_keys "Created by using Automation"
      
      getElement_xpath("due_date").click
      #wait
      #getElement_xpath("date_next").click
      wait
      getElement_xpath("date_select").click

      getElement_xpath("record_payment").click
    
      wait

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item
   end

end
