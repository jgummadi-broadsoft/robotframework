*** Settings ***
Documentation    Register test-cases to register different user to system

Resource   common.robot
Test Teardown     Register Test Teardown
Suite Teardown    Register Suite Teardown
Library          String

*** Test Cases ***
Valid Register
    ${valid user}  ${VALID PASSWORD1}   Register Username
    Verify Login    ${LOGIN URL}    Log In - Demo App
    [Teardown]    Close All Browsers

Valid Already Register User
    ${valid user}  ${valid password}   Register Username
    Fill Register Details    ${valid user}    ${valid password}
    Verify Login    ${REGISTER URL}    Register - Demo App
    [Teardown]    Close All Browsers

*** Keywords ***
Register Test Teardown
    Close Browser

Register Suite Teardown
    Close All Browsers