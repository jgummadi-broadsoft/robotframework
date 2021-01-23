*** Settings ***
Documentation     A common library contains common variable and keywords for test suite

Library           SeleniumLibrary

*** Variables ***
${SERVER}         localhost:8080
${BROWSER}        Chrome
${DELAY}          0
${REGISTER URL}   http://${SERVER}/register
${LOGIN URL}      http://${SERVER}/login
${USER URL}      http://${SERVER}/user
${LOGOUT URL}      http://${SERVER}/logout
${ERROR URL}      http://${SERVER}/error
${YOUTUBE URL}      https://youtu.be/ZXVU3Lbgt9Y
${RANDOM STRING LENGTH}    10


*** Keywords ***
Open Browser To Register Login
    [Arguments]      ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Register Should Be Open
    Title Should Be  Register - Demo App

Go To Register - Demo App
    Go To    ${REGISTER URL}
    Register - Demo App Should Be Open

Submit Credentials

    Click Button  css:input[type='submit']

Log In - Demo App
    [Arguments]      ${url}
    Location Should Be    ${url}
    Title Should Be    Log In - Demo App

Go To Log In - Demo App
    Go To    ${LOGIN URL}
    Login - Demo App    ${LOGIN URL}

User Information - Demo App
    Location Should Be    ${USER URL}
    Title Should Be    User Information - Demo App

Register User already exists - Demo App
    Title Should Be  Register - Demo App

Verify Login
    [Arguments]      ${url}    ${text}
    Location Should Be    ${url}
    Title Should Be    ${text}
    Go To Log In - Demo App

Register Username
    ${username} =    Generate Random String
    ${phone} =    Generate Random String  ${RANDOM STRING LENGTH}  [NUMBERS]
    Fill Register Details    ${username}    ${username}
    [Return]    ${username}    ${username}

Fill Register Details
    [Arguments]    ${username}    ${password}
    Open Browser To Register Login    ${REGISTER URL}    ${BROWSER}
    Register Should Be Open
    @{fieldlist} =    Create List  username  password  firstname  lastname  phone
    :FOR    ${field}    IN    @{fieldlist}
    \    Input Text    ${field}    ${username}
    \    Input Text    ${field}    ${password}
    Submit Credentials
