*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    Collections
Library    RPA.Tables
Library    RPA.PDF

*** Tasks ***
Avaa verkkosivu
    Open Duunitori Website

Hakusanat
    Lisää hakusanat
Haeppas niitä röitä
    Avaa hakemukset ja ota screenshot 


*** Variables ***
${SCREENSHOT_PATH-DUUNITORI}    ./output/screenshots-duunitori/screenshot.png

*** Keywords ***
Open Duunitori Website
    Open Available Browser    https://www.duunitori.fi
    Maximize Browser Window    # Make the browser window full screen

Lisää hakusanat
    Delete All Cookies
    Click Element When Visible    xpath://button[text()='Hyväksy evästeet']
    Execute JavaScript    var element = document.querySelector("div.form__input.form__input--fake.form__input--border.form__input--icon.js-nav-toggle-search"); element.innerText = "It"; element.dispatchEvent(new Event('input', { bubbles: true }));
    Input Text    css:.taggle_input    IT 
    Press Keys    css:.taggle_input    TAB
    Input Text    css:.taggle_input    designer
    Press Keys    css:.taggle_input    TAB
    Input Text    css:.taggle_input    developer
    Press Keys    css:.taggle_input    TAB
    Press Keys    None    Pääkaupunkiseutu   
    Click Element    js-form__search--submit 
    Execute JavaScript    document.evaluate("//button[contains(text(), 'Uusimmat')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();



Avaa hakemukset ja ota screenshot 
    Wait Until Element Is Visible    xpath://a[contains(@class, 'job-box__hover')]
    ${job_elements}=    Get WebElements    xpath://a[contains(@class, 'job-box__hover') and contains(@class, 'gtm-search-result')]
    
    FOR    ${index}    IN RANGE    0    20
        # Re-fetch the list of job elements to avoid stale references
        ${job_elements}=    Get WebElements    xpath://a[contains(@class, 'job-box__hover') and contains(@class, 'gtm-search-result')]

        # Ensure there are enough elements
        Exit For Loop If    ${index} >= ${job_elements.__len__()}

        ${job_element}=    Get From List    ${job_elements}    ${index}
        
        # Scroll to the element and wait until it is clickable
        Scroll Element Into View    ${job_element}
        Wait Until Element Is Visible    ${job_element}
        Wait Until Element Is Visible    ${job_element}
        Sleep    2s    # Adjust if necessary

        # Click the element and wait for page load
        Click Element    ${job_element}
        Sleep    2s

        # Set the window to full page height for capturing the full page screenshot
        ${original_size}=    Get Window Size
        ${total_height}=    Execute JavaScript    return document.body.scrollHeight
        Set Window Size    ${original_size}[0]    ${total_height}

        # Take a full page screenshot with a unique filename
        ${screenshot_path}=    Set Variable    ./output/screenshots-duunitori/screenshot_${index + 1}.png
        Capture Page Screenshot    ${screenshot_path}

        # Revert window size after the screenshot
        Set Window Size    ${original_size}[0]    ${original_size}[1]

        # Navigate back to the job list and wait
        Go Back
        Wait Until Element Is Visible    xpath://a[contains(@class, 'job-box__hover')]
        Sleep    2s
    END






