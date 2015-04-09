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
    @driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to create project
  def test_project

      @@present = " "+get_Present 
      check_product(@@present)

      get_Company

      getElement_xpath("customer_more").click
      getElement_text_direct("Project").click
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
      wait
      getElement_xpath("date_next").click
      wait
      getElement_xpath("date_select").click
      getElement_xpath("sales_rep").send_keys "Ravi"      
      getElement_xpath("production_manager").send_keys "Ravi"      
      getElement_xpath("project_manager").send_keys "Ravi"      
      getElement_xpath("record_payment").click   
      wait
      getElement_placeholder("Search...").send_keys pro_name
      wait

     #begin 
        actual = getElement_xpath("project_table").text
        status = compare(actual,pro_name)
        if(status)
          puts "Project created successfully"
          getElement_text_direct(pro_name).click
          wait          
          add_order
          get_project(pro_name) 
          add_quote       
          get_project(pro_name)  
          add_invoice          
          check_pipeline             
          get_project(pro_name)
          add_sales_lead
          get_project(pro_name)     
          add_job     
        else
          puts "Project not created"
        end
     # rescue
     #   puts "Project not created"
     # end
   end

   def get_project(project_name)
      getElement_text("project").click
      getElement_text_direct(project_name).click
      wait
   end

   def add_quote
      getElement_xpath("quote_more").click
      getElement_text("project_quote").click
      getElement_placeholder("Title").send_keys "Automation Quote "+get_Present
      getElement_placeholder_text("About").send_keys "Created by using Automation"      
      getElement_xpath("record_payment").click    
      wait
      puts "Quote Name : "+getElement_xpath("trans_name").text
      add_line_item(@@present)
   end

   def add_order    
      getElement_xpath("quote_more").click
      getElement_text("project_order").click
      getElement_placeholder("Title").send_keys "Automation Order "+get_Present       
      getElement_placeholder_text("About").send_keys "Created by using Automation"    
      getElement_xpath("txn_date").click
      wait
      getElement_xpath("date_next").click
      wait
      getElement_xpath("date_select").click
      wait
      @@date_selected = getElement_placeholder("Select Sales Order date").attribute("value")    
      getElement_placeholder("Select due date").send_keys @@date_selected      
      getElement_placeholder("Select ship date").send_keys @@date_selected
      getElement_xpath("record_payment").click    
      wait
      puts "Order Name : "+getElement_xpath("trans_name").text
      add_line_item(@@present)
   end

   def add_invoice  
      getElement_xpath("quote_more").click
      getElement_text("project_invoice").click
      getElement_placeholder("Title").send_keys "Automation Invoice "+get_Present       
      getElement_placeholder_text("About").send_keys "Created by using Automation"                 
      getElement_placeholder("Select due date").send_keys @@date_selected
      getElement_placeholder("Select ship date").send_keys @@date_selected
      getElement_xpath("record_payment").click    
      wait
      puts "Invoice Name : "+getElement_xpath("trans_name").text
      add_line_item(@@present)
   end

   def add_job
      getElement_xpath("quote_more").click
      getElement_text("project_job").click
      job_name = "Automation Job "+get_Present
      getElement_placeholder("Name").send_keys job_name 
      getElement_placeholder_text("Description").send_keys "Created by using Automation"          
      getElement_placeholder("Quantity").send_keys 3
      getElement_xpath("job_due_date").send_keys @@date_selected
      getElement_xpath("save").click
      wait
      puts "Job Name : " +getElement_xpath("job_name").text
   end

   def add_sales_lead
      getElement_xpath("quote_more").click
      getElement_text("project_sl").click 
      sl_name = Keys_CONFIG["sales_lead_name"] + " "+ get_Present
      getElement_placeholder("Title").send_keys sl_name
      getElement_placeholder_text("Details").send_keys Keys_CONFIG["sales_lead_description"]
      getElement_xpath("pipeline_select").send_keys Keys_CONFIG["pipeline_name"]    
      getElement_xpath("save").click
      wait
      sales_lead = getElement_xpath("company_name").text
      puts "Sales Lead Name : #{sales_lead} created successfully"
   end

   def check_pipeline
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
   end

end
