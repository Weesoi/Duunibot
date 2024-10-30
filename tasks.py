from RPA.Browser.Selenium import Selenium
from bs4 import BeautifulSoup
import csv
from RPA.Email.ImapSmtp import ImapSmtp

# Vaihe 1: Selaimen avaus ja työpaikkasivulle siirtyminen
browser = Selenium()
browser.open_available_browser("https://jobly.fi")

html_content = browser.get_page_source()
soup = BeautifulSoup(html_content, "html.parser")
job_listings = soup.find_all("div", class_="job-listing")

jobs = []
for job in job_listings:
    title = job.find("h2").text
    location = job.find("span", class_="location").text
    if "työharjoittelu" in title.lower() and "Helsinki" in location:
        jobs.append({
            "title": title,
            "location": location,
            "link": job.find("a")["href"]
        })

with open("matching_jobs.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Title", "Location", "Link"])
    for job in jobs:
        writer.writerow([job["title"], job["location"], job["link"]])

mail = ImapSmtp()
mail.authorize("smtp.gmail.com", "email@example.com", "password")
mail.send_message(
    sender="email@example.com",
    recipients=["student@example.com"],
    subject="Sopivat työpaikkailmoitukset",
    body="Liitteenä CSV sopivista työpaikoista.",
    attachments=["matching_jobs.csv"]
)

browser.input_text("xpath://input[@name='first_name']", "Opiskelijan Nimi")
browser.input_text("xpath://input[@name='last_name']", "Sukunimi")
browser.upload_file("xpath://input[@type='file']", "CV.pdf")
browser.click_button("xpath://button[@type='submit']")

browser.close_browser()
