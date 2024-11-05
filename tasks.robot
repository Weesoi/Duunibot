*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}

*** Tasks ***
Avaa verkkosivu
    Open Duunitori Website

Hakusanat
    Lisää hakusanat

Testi Screenshot
    Avaa hakemukset ja ota screenshot 


*** Variables ***
${SCREENSHOT_PATH-DUUNITORI}    ./output/screenshots-duunitori/screenshot.png
${SCREENSHOT_PATH-JOBLY}
${SCREENSHOT_PATH-OIKOTIE}

*** Keywords ***
Open Duunitori Website
    Open Available Browser    https://www.duunitori.fi

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
#lisää tähän for-loop 
    Capture Page Screenshot    ${SCREENSHOT_PATH-DUUNITORI}
#<----->

