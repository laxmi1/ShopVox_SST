load File.dirname(__FILE__) +  '/../test_helper.rb'


class Job < Test::Unit::TestCase 
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
  
# Test to create job from company page and send proof for review
  def test_job_from_company_page
      get_Company

      getElement_xpath("company_actions").click

      # click on job link
      getElement_xpath("job_company").click
      
      job_name = "Automation Job "+get_Present

      getElement_placeholder("Name").send_keys job_name 

      getElement_placeholder_text("Description").send_keys "Created by using Automation"
           
      getElement_placeholder("Quantity").send_keys 3

      getElement_xpath("due_date_cal").click

      getElement_xpath("date_next").click

      getElement_xpath("date_select").click

      getElement_xpath("save").click

      sleep(10)

      getElement_text("start_design").click

      getElement_text("upload_proof").click

      getElement_text("select_proof").click

      main_window = @driver.window_handle

      @driver.switch_to.frame(Keys_CONFIG["file_picker"])

      path = get_path+"/Images/stat.jpg"

      getElement_id("proof_upload_id").send_keys path

      @driver.switch_to.window(main_window)  
      
      sleep(10)

      getElement_xpath("popup_save").click

      sleep(5)

      getElement_xpath("send_review").click

      sleep(10)

      getElement_xpath("type_user").send_keys Keys_CONFIG["company_contact_data"]
      
      sleep(5)
      
      getElement_xpath("select_user").click

      getElement_xpath("popup_save").click

      sleep(8)

      puts   getElement_xpath("review_success_class").text

      # wait_for_ajax(@driver)
   end

end
