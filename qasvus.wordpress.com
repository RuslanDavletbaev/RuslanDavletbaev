from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

# create a new Chrome browser instance
driver = webdriver.Chrome()

# navigate to the test website
driver.get("https://qasvus.wordpress.com")

# maximize the browser window
driver.maximize_window()

# verify the website title
assert "California Real Estate" in driver.title

# print the website title
print(driver.title)

# find the "Send Us a Message" text on the webpage
message_text = driver.find_element_by_id("//h3[contains(text(),'Send Us a Message')]")

# scroll to the "Send Us a Message" text
driver.execute_script("arguments[0].scrollIntoView();", message_text)

# fill out the message form and send it
name_field = driver.find_element_by_id("g2-name")
name_field.send_keys("John Doe")

email_field = driver.find_element_by_id("g2-email")
email_field.send_keys("johndoe@example.com")

message_field = driver.find_element_by_id("contact-form-comment-g2-message")
message_field.send_keys("This is a test message.")

submit_button = driver.find_element_by_xpath("//input[@value='Send']")
submit_button.click()

# wait for the message to be sent
WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, "//div[@class='wpcf7-response-output wpcf7-display-none wpcf7-mail-sent-ok']")))

# find the "go back" button and click it
go_back_link = driver.find_element_by_link_text("go back")
go_back_link.click()

# verify the Main page by finding and printing the "type" for the "Submit" button
submit_button = driver.find_element_by_xpath("//input[@type='submit']")
print(submit_button.get_attribute("type"))

# close the browser window
driver.quit()
