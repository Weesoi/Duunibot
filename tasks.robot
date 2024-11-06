*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    Collections
Library    RPA.Tables

*** Tasks ***
Avaa verkkosivu
    Open Duunitori Website

Hakusanat
    Lisää hakusanat

Testi Screenshot
    Avaa hakemukset ja ota screenshot 
Haeppas niitä röitä
    Avaa hakemukset ja ota screenshot 


*** Variables ***
${SCREENSHOT_PATH-DUUNITORI}    ./output/screenshots-duunitori/screenshot.png
${SCREENSHOT_PATH-JOBLY}
${SCREENSHOT_PATH-OIKOTIE}

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
        ${job_element}=    Get From List    ${job_elements}    ${index}
        Scroll Element Into View    ${job_element}
        Click Element    ${job_element}
        Sleep    1s    # Optional: pause for a moment between clicks
        
        # Dynamically create the screenshot path with an incrementing number
        ${screenshot_path}=    Set Variable    ./output/screenshots-duunitori/screenshot_${index + 1}.png
        Capture Page Screenshot    ${screenshot_path}
        
        Go Back    # Return to the job list page
    END


