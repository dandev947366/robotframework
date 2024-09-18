*** Settings ***
Library           OperatingSystem
Library           Collections
Library           String
Library           Process

*** Variables ***
${INPUT_FILE}     webpages.txt
${OUTPUT_FILE}    ping_results.txt

*** Test Cases ***
Ping Each Address And Save Results
    [Documentation]    Read URLs from ${INPUT_FILE}, ping each one, save IP address and average ping time to ${OUTPUT_FILE}, and verify the ping time is less than 50ms.

    # Read the file into a variable
    ${file_content}=   Get File    ${INPUT_FILE}
    
    # Split the content into a list of websites
    @{webpages}=       Split String    ${file_content}    \n
    
    # Open the output file for writing
    Create File    ${OUTPUT_FILE}
    
    # Loop through each webpage and ping the address
    FOR    ${webpage}    IN    @{webpages}
        Log To Console   Pinging ${webpage}
        
        # Execute the ping command for each webpage (Mac: -c 4 for 4 pings)
        ${result}=    Run Process    ping    ${webpage}    -c 4    stdout=True    stderr=True    shell=True
        
        # Capture the standard output
        ${ping_output}=    Set Variable    ${result.stdout}
        
        # Extract IP address and average ping time
        ${ip_address}=    Get IP Address    ${ping_output}
        ${avg_ping_time}=    Get Average Ping Time    ${ping_output}
        
        # Log the IP and average ping time
        Log To Console   ${webpage} - IP: ${ip_address} - Avg Time: ${avg_ping_time} ms
        
        # Write results to the output file
        Append To File    ${OUTPUT_FILE}    ${webpage} - IP: ${ip_address} - Avg Time: ${avg_ping_time} ms
        
        # Test if the average ping time is less than 50ms
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
