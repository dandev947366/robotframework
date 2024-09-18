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
    
    # Read the file into a variable
    ${file_content}=   Get File    ${INPUT_FILE}
    
    # Split the content into a list of websites
    @{webpages}=       Split String    ${file_content}    \n
    
    # Loop through each webpage and ping the address
    FOR    ${webpage}    IN    @{webpages}
        Log To Console   Pinging ${webpage}
        
        # Execute the ping command for each webpage (Mac: -c 4 for 4 pings)
        ${result}=    Run Process    ping    ${webpage}    -c 4    stdout=True    stderr=True    shell=True
        
        # Capture the standard output directly
        ${ping_output}=    Set Variable    ${result.stdout}
        
        # Log the ping result to the console
        Log To Console   ${ping_output}
    END
