*** Settings ***
Library           String
Library           Collections
Library           SSHLibrary
Library           RequestsLibrary

Resource   common.robot
*** Variables ***
${username} =  Test999
${url} =   http://localhost:8080

*** Test Cases ***
authorization api check test
    ${valid user}  ${valid password}   Register Username
    ${auth} =  Create List  ${valid user}  ${valid password}
    Create Session  myssion  ${url}   auth=${auth}
    ${resp}=  Set Header And Check Response    ${EMPTY}

    Should Be Equal As Strings  ${resp.status_code}  200
    &{data}=    Evaluate     json.loads($resp.content)    json
    Should Be Equal As Strings  &{data}[status]   SUCCESS

    [Teardown]    Close All Browsers

autorization update api check test
    ${valid user}  ${valid password}   Register Username
    ${auth} =  Create List  ${valid user}  ${valid password}
    Create Session  myssion  ${url}   auth=${auth}
    ${resp}=  Set Header And Check Response    ${EMPTY}

    Should Be Equal As Strings  ${resp.status_code}  200
    &{data}=    Evaluate     json.loads($resp.content)    json
    ${token}=  Set variable     ${resp.json()['token']}
    Should Be Equal As Strings  &{data}[status]   SUCCESS

    &{headersToken}=    Create Dictionary       Accept=application/json, text/plain, */*    Content-Type=application/json       token=${token}
    &{requestData}=    Create Dictionary       firstname=zzzz      lastname=rrrr       phone=987654
    ${updateresp}=      Put Request     myssion     /api/users/${username}      ${requestData}      headers=${headersToken}

    [Teardown]    Close All Browsers

get users api check test
    ${valid user}  ${valid password}   Register Username
    ${auth} =  Create List  {valid user}  ${valid password}
    Create Session  myssion  ${url}   auth=${auth}
    &{headers}=    Create Dictionary   Accept=application/json, text/plain, */*    Content-Type=application/json
    ${resp}=  Get Request  myssion  /api/users   headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

    [Teardown]    Close All Browsers

*** Keywords ***
Set Header And Check Response
    [Arguments]    ${token}
    &{headers}=    Create Dictionary       Accept=application/json, text/plain, */*    Content-Type=application/json       token=${token}
    ${resp}=  Get Request  myssion  /api/auth/token   headers=${headers}
    [Return]    ${resp}

Put Header Request
    [Arguments]    ${token}
    &{headers}=    Create Dictionary       Accept=application/json, text/plain, */*    Content-Type=application/json       token=${token}
    &{requestData}=    Create Dictionary       firstname=zzzz      lastname=rrrr       phone=987654
    ${updateresp}=      Put Request     myssion     /api/users/${username}      ${requestData}      headers=${headers}




