from RPA.Browser.Selenium import Selenium
from bs4 import BeautifulSoup
import csv
from RPA.Email.ImapSmtp import ImapSmtp
from robocorp.tasks import task

@task
def Jobly():
    browser = Selenium()
    browser.open_available_browser("https://jobly.fi")

    # Yritetään hyväksyä evästeet CSS-valitsimella
    try:
        browser.wait_until_element_is_visible("css:button.message-component.message-button.no-children.focusable.alma-cmp-button.sp_choice_type_11", timeout=10)
        browser.click_button("css:button.message-component.message-button.no-children.focusable.alma-cmp-button.sp_choice_type_11")
    except:
        print("Evästepopupia ei löytynyt tai sitä ei tarvinnut hyväksyä.")

    # Jatka robotin toimintaa tästä eteenpäin...
    # browser.input_text("xpath://input[@name='first_name']", "Opiskelijan Nimi")
    # browser.input_text("xpath://input[@name='last_name']", "Sukunimi")
    # browser.upload_file("xpath://input[@type='file']", "CV.pdf")
    # browser.click_button("xpath://button[@type='submit']")

    # browser.close_browser()