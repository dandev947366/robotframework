*** Settings ***
Library           OperatingSystem
Library           Collections
Library           String  # Add the String library to use Split String

*** Variables ***
${INPUT_FILE}     webpages.txt

*** Test Cases ***
Read Webpages Into A Variable
    [Documentation]    Read the contents of webpages.txt into a variable.
    
    # Read the file into a variable
    ${file_content}=   Get File    ${INPUT_FILE}
    
    # Split the content into a list of websites
    @{webpages}=       Split String    ${file_content}    \n
    
    # Log to console to check the variable content
    Log To Console     Webpages in file:\n@{webpages}
