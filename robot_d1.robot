*** Settings ***
Library         SeleniumLibrary

*** Variables ***
${URL}         https://www.google.co.th/
${BROWSER}     headlesschrome
#${BROWSER}     chrome
${DELAY}       0
*** Keywords ***
staff list case
    Open Browser                ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed          ${DELAY}
    Capture Page Screenshot     custom_name.png
*** Test Cases ***
cc
    staff list case
    

    # Close Browser
