*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    Collections
Library    RPA.Tables
Library    RPA.PDF
Library    OperatingSystem

*** Variables ***
${BASE_OUTPUT_DIRECTORY}          C:/Users/sokri/Duunibot/Duunibot/output/screenshots-duunitori
${PDF_FILE}                       ${BASE_OUTPUT_DIRECTORY}/pdf/website_info.pdf
${SCREENSHOT_DIRECTORY}           ${BASE_OUTPUT_DIRECTORY}
${TITLE_SCREENSHOT_DIRECTORY}     ${BASE_OUTPUT_DIRECTORY}/titles
${PDF_DIRECTORY}                  ${BASE_OUTPUT_DIRECTORY}/pdf

*** Tasks ***
Avaa verkkosivu ja tallenna työilmoitukset PDF-tiedostoon

    Open Duunitori Website
    Lisää hakusanat
    ${job_data}=    Avaa hakemukset ja ota screenshot 
    Kokoa PDF    ${job_data}

*** Keywords ***



Open Duunitori Website
    Open Available Browser    https://www.duunitori.fi
    Maximize Browser Window

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
    ${job_data}=    Create List

    Wait Until Element Is Visible    xpath://a[contains(@class, 'job-box__hover')]
    ${job_elements}=    Get WebElements    xpath://a[contains(@class, 'job-box__hover') and contains(@class, 'gtm-search-result')]

    FOR    ${index}    IN RANGE    0    20
        ${job_elements}=    Get WebElements    xpath://a[contains(@class, 'job-box__hover') and contains(@class, 'gtm-search-result')]
        Exit For Loop If    ${index} >= ${job_elements.__len__()}

        ${job_element}=    Get From List    ${job_elements}    ${index}
        
        Scroll Element Into View    ${job_element}
        Wait Until Element Is Visible    ${job_element}
        Sleep    2s

        Click Element    ${job_element}
        Sleep    5s

        ${original_size}=    Get Window Size
        ${total_height}=    Execute JavaScript    return document.body.scrollHeight
        Set Window Size    ${original_size}[0]    ${total_height}
        Sleep    3s

        ${screenshot_path}=    Set Variable    ${SCREENSHOT_DIRECTORY}/screenshot_${index + 1}.png
        Capture Page Screenshot    ${screenshot_path}
        Sleep    3s
        
        Wait Until Element Is Visible    xpath://h1
        ${title_screenshot_path}=    Set Variable    ${TITLE_SCREENSHOT_DIRECTORY}/title_screenshot_${index + 1}.png
        Capture Element Screenshot    xpath://h1    ${title_screenshot_path}

        ${current_url}=    Get Location
        ${job_entry}=    Create Dictionary    url=${current_url}    full_screenshot=${screenshot_path}    title_screenshot=${title_screenshot_path}
        Append To List    ${job_data}    ${job_entry}

        Set Window Size    ${original_size}[0]    ${original_size}[1]
        #go back komento ei täysin toimi, ja se aiheuttaakin ongelmia koko koodin toimivuudessa
        Go Back
        Wait Until Element Is Visible    xpath://a[contains(@class, 'job-box__hover')]
        Sleep    2s
    END

    [Return]    ${job_data}

Kokoa PDF
    [Arguments]    ${job_data}

    ${html_content}=    Set Variable    <html><body><h1>Duunitorin 20 uusinta ilmoitusta:</h1>

    FOR    ${job}    IN    @{job_data}
        ${url}=    Get From Dictionary    ${job}    url
        ${full_screenshot}=    Get From Dictionary    ${job}    full_screenshot
        ${title_screenshot}=    Get From Dictionary    ${job}    title_screenshot
        
        ${html_content}=    Set Variable    ${html_content}<html><body><h1>Hakemus tiedot:</h1>
        ${html_content}=    Set Variable    ${html_content}<p>URL: <a href="${url}">${url}</a></p>
        ${html_content}=    Set Variable    ${html_content}<img src="${full_screenshot}" width="500" height="300"><br>
        ${html_content}=    Set Variable    ${html_content}<img src="${title_screenshot}" width="200" height="60"><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    END

    ${html_content}=    Set Variable    ${html_content}</body></html>
    HTML To PDF    ${html_content}    ${PDF_FILE}
    Log To Console    Tiedot on tallennu nyt tiedostoon: ${PDF_FILE}
