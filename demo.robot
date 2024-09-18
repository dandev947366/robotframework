*** Test Cases ***
Ping Each Webpage And Write Results
    [Documentation]    Ping each URL, capture IP, average ping time, and write the results to a new file.
    
    # Delete the file if it exists to avoid appending to an old file
    Remove File If Exists    ${OUTPUT_FILE}

    # Read webpages from the file
    ${file_content}=   Get File   ${INPUT_FILE}
    @{webpages}=       Split String    ${file_content}    \n
    Log To Console     Webpages to ping: @{webpages}

    # Loop through each webpage and ping it
    FOR    ${webpage}    IN    @{webpages}
        Log To Console    Pinging ${webpage}
        ${ping_result}=   Run Process    ping    ${webpage}    -c    ${PING_COUNT}    shell=True
        Log To Console    Ping result for ${webpage}:\n${ping_result.stdout}
        ${ip_address}=    Extract IP Address   ${ping_result.stdout}
        ${avg_ping_time}= Extract Ping Time    ${ping_result.stdout}
        Log To Console    IP Address: ${ip_address}, Average Ping Time: ${avg_ping_time} ms
        
        # Test if the average ping time is less than 50ms
        Should Be True    ${avg_ping_time} < ${MAX_PING_TIME}    Ping time is greater than 50ms

        # Write the IP address and average ping time to the output file
        Write Ping Results To File    ${webpage}    ${ip_address}    ${avg_ping_time}
    END
