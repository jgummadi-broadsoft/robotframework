*** Settings ***
Documentation    Login test-cases in different login combinations


Resource   common.robot
Library  String

Force Tags   login    smoke-test

Suite Setup    Login Suite Setup
Suite Teardown    Login Suite Teardown
Test Setup        Login Test Setup
Test Teardown     Login Test Teardown
Test Template     Verify Login Behaviour

*** Variables ***
${WRONG USERNAME}    dummyuser
${WRONG PASSWORD}    welcome1

${LOGIN_SCREEN}      User Information - Demo App
${FAILURE_MSG}    Login Failure - Demo App

*** Test Cases ***                          USER NAME           PASSWORD               EXPECTED URL      EXPECTED MSG
Verify Login For Successful Case            ${VALID USER}       ${VALID PASSWORD}       ${USER URL}      ${LOGIN_SCREEN}
Verify Login With Wrong User                ${WRONG USERNAME}   ${VALID PASSWORD}       ${ERROR URL}     ${FAILURE_MSG}
Verify Login With Wrong Password            ${VALID USER}       ${WRONG PASSWORD}       ${ERROR URL}     ${FAILURE_MSG}
Verify Login With Wrong User And Password   ${WRONG USERNAME}   ${WRONG PASSWORD}       ${ERROR URL}     ${FAILURE_MSG}

*** Keywords ***
Verify Login Behaviour
    [Arguments]      ${username}    ${password}    ${expected_url}    ${expected_msg}
    Do Login   ${username}    ${password}
    Verify Login    ${expected_url}    ${expected_msg}

Do Login
   [Arguments]      ${username}    ${password}
   Input Text    username    ${username}
   Input Text    password    ${password}
   Submit Credentials

Login Suite Setup
    ${VALID USER}  ${VALID PASSWORD}  Register Username
    Set Global Variable  ${VALID USER}
    Set Global Variable  ${VALID PASSWORD}

Login Test Setup
    Open Browser To Register Login    ${LOGIN URL}    ${BROWSER}
    Log In - Demo App    ${LOGIN URL}

Login Test Teardown
    Close Browser

Login Suite Teardown
    Close All Browsers
