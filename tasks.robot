*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}

*** Tasks ***
Avaa verkkosivu
    Open Duunitori Website

Hakusanat
    Lisää hakusanat

*** Keywords ***
Open Duunitori Website
    Open Available Browser    https://www.duunitori.fi

Lisää hakusanat
    Delete All Cookies
    Click Element When Visible    xpath://button[text()='Hyväksy evästeet']
    Input Text     xpath://div[@class='form__input form__input--fake form__input--border form__input--icon js-nav-toggle-search']    It   It
    Input Text    css:.taggle_input    Pääkaupunkiseutu