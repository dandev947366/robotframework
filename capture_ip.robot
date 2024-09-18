*** Settings ***
Library           OperatingSystem
Library           Collections
Library           String
Library           Process

*** Variables ***
${INPUT_FILE}     webpages.txt

*** Test Cases ***
Ping Each Address And Verify Time
    [Documentation]    Read URLs from webpages.txt, ping each one, and verify the ping time is less than 50ms.

    # Step 1: Read the file into a variable
    ${file_content}=   Get File    ${INPUT_FILE}
    
    # Step 2: Split the content into a list of websites
    @{webpages}=       Split String    ${file_content}    \n
    
    # Step 3: Loop through each webpage and ping the address
    FOR    ${webpage}    IN    @{webpages}
        Log To Console   Pinging ${webpage}
        
        # Step 4: Execute the ping command for each webpage (Mac: -c 4 for 4 pings)
        ${result}=    Run Process    ping    ${webpage}    -c 4    stdout=True    stderr=True    shell=True
        
        # Step 5: Capture the standard output
        ${ping_output}=    Set Variable    ${result.stdout}
        
        # Step 6: Extract IP address and average ping time
        ${ip_address}=    Get IP Address    ${ping_output}
        ${avg_ping_time}=    Get Average Ping Time    ${ping_output}
        
        # Step 7: Log the IP and average ping time
        Log To Console   ${webpage} - IP: ${ip_address} - Avg Time: ${avg_ping_time} ms
        
        # Step 8: Test if the average ping time is less than 50ms
        Run Keyword If    ${avg_ping_time} < 50    Log To Console   ${webpage} is faster than 50ms.
        Run Keyword If    ${avg_ping_time} >= 50    Fail    ${webpage} took ${avg_ping_time}ms, which is greater than 50ms.

    END

*** Keywords ***
Get IP Address
    [Arguments]    ${ping_output}
    ${lines}=    Split String    ${ping_output}    \n
    ${ip_line}=    Get From List    ${lines}    0
    ${ip_address}=    Split String    ${ip_line}    \( 
    ${ip_address}=    Split String    ${ip_address[1]}    \)
    ${ip_address}=    Strip String    ${ip_address[0]}
    RETURN    ${ip_address}

Get Average Ping Time
    [Arguments]    ${ping_output}
    ${lines}=    Split String    ${ping_output}    \n
    ${avg_line}=    Get From List    ${lines}    -1
    ${avg_time}=    Split String    ${avg_line}    = 
    ${avg_time}=    Strip String    ${avg_time[1].split()[0]}
    RETURN    ${avg_time}
