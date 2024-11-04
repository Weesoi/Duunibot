*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.duunitori.fi

*** Test Cases ***
Open Duunitori Website
    [Documentation]    This test opens the Duunitori website and verifies the title
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    [Teardown]    Close Browser
