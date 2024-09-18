*** Settings ***
Library           OperatingSystem
Library           Collections
Library           String
Library           Process

*** Variables ***
${INPUT_FILE}     webpages.txt

*** Test Cases ***
Ping Each Address
    [Documentation]    Read URLs from webpages.txt and ping each one.
    
    # Step 1: Read the file into a variable
    ${file_content}=   Get File    ${INPUT_FILE}
    
    # Step 2: Split the content into a list of websites
    @{webpages}=       Split String    ${file_content}    \n
    
    # Step 3: Loop through each webpage and ping the address
    FOR    ${webpage}    IN    @{webpages}
        Log To Console   Pinging ${webpage}
        
        # Step 4: Execute the ping command for each webpage (Mac: -c 4 for 4 pings)
        ${result}=    Run Process    ping    ${webpage}    -c 4    stdout=True    stderr=True    shell=True
        
        # Step 5: Capture the standard output directly
        ${ping_output}=    Set Variable    ${result.stdout}
        
        # Step 6: Log the ping result to the console
        Log To Console   ${ping_output}
    END
