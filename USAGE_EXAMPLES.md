# Usage Examples and Implementation Patterns

## Overview

This document provides comprehensive usage examples, implementation patterns, and real-world scenarios for the Robot Framework test automation project. It demonstrates how to effectively use the APIs, functions, and components in various testing contexts.

## Table of Contents

- [Basic Usage Patterns](#basic-usage-patterns)
- [Advanced Implementation Examples](#advanced-implementation-examples)
- [Real-World Scenarios](#real-world-scenarios)
- [Integration Patterns](#integration-patterns)
- [Testing Strategies](#testing-strategies)
- [Performance Optimization Examples](#performance-optimization-examples)
- [Error Handling Patterns](#error-handling-patterns)
- [CI/CD Integration](#cicd-integration)

## Basic Usage Patterns

### 1. Simple Test Execution

**Scenario:** Running a basic web automation test

```bash
# Execute the default test
robot robot_d1.robot

# Execute with verbose output
robot --console verbose robot_d1.robot

# Execute with custom log level
robot --loglevel INFO robot_d1.robot
```

**Expected Output:**
```
==============================================================================
Robot D1                                                                      
==============================================================================
cc                                                                    | PASS |
------------------------------------------------------------------------------
Robot D1                                                              | PASS |
1 critical test, 1 passed, 0 failed
1 test total, 1 passed, 0 failed
==============================================================================
```

### 2. Variable Customization

**Scenario:** Testing different websites and browsers

```bash
# Test Google with Chrome GUI
robot --variable URL:https://www.google.com --variable BROWSER:chrome robot_d1.robot

# Test different site with Firefox
robot --variable URL:https://example.com --variable BROWSER:firefox robot_d1.robot

# Test with execution delay
robot --variable DELAY:2 robot_d1.robot
```

### 3. Output Customization

**Scenario:** Organizing test results

```bash
# Custom output directory
robot --outputdir test_results robot_d1.robot

# Custom report and log names
robot --report google_test_report.html --log google_test_log.html robot_d1.robot

# Timestamped results
robot --timestampoutputs robot_d1.robot
```

## Advanced Implementation Examples

### 1. Enhanced Test Suite with Multiple Test Cases

**File:** `enhanced_robot_suite.robot`

```robot
*** Settings ***
Library         SeleniumLibrary
Suite Setup     Setup Test Suite
Suite Teardown  Cleanup Test Suite

*** Variables ***
${URL}              https://www.google.co.th/
${BROWSER}          headlesschrome
${DELAY}            0
${SCREENSHOT_DIR}   screenshots
${TIMEOUT}          30s

*** Keywords ***
Setup Test Suite
    [Documentation]    Initialize test suite environment
    Create Directory    ${SCREENSHOT_DIR}
    Set Selenium Timeout    ${TIMEOUT}
    Log    Test suite started at ${CURDATE} ${CURTIME}

Cleanup Test Suite
    [Documentation]    Clean up after test suite
    Close All Browsers
    Log    Test suite completed at ${CURDATE} ${CURTIME}

Enhanced Staff List Case
    [Documentation]    Enhanced version with error handling and validation
    [Arguments]    ${url}=${URL}    ${browser}=${BROWSER}    ${screenshot_name}=default.png
    
    # Browser setup with retry logic
    FOR    ${attempt}    IN RANGE    3
        ${status}=    Run Keyword And Return Status    Open Browser    ${url}    ${browser}
        Exit For Loop If    ${status}
        Log    Browser open attempt ${attempt + 1} failed, retrying...
        Sleep    2s
    END
    Should Be True    ${status}    Failed to open browser after 3 attempts
    
    # Window management
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    
    # Page validation
    Wait Until Page Contains Element    body    timeout=${TIMEOUT}
    ${title}=    Get Title
    Log    Page title: ${title}
    
    # Screenshot with organized naming
    ${screenshot_path}=    Set Variable    ${SCREENSHOT_DIR}/${screenshot_name}
    Capture Page Screenshot    ${screenshot_path}
    Log    Screenshot saved: ${screenshot_path}
    
    # Return useful information
    [Return]    ${title}

Validate Page Content
    [Documentation]    Validate basic page content and structure
    [Arguments]    ${expected_title_contains}=Google
    
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_title_contains}
    Page Should Contain Element    body
    ${url}=    Get Location
    Log    Current URL: ${url}

*** Test Cases ***
Basic Google Test
    [Documentation]    Basic test case for Google homepage
    [Tags]    smoke    basic
    
    ${title}=    Enhanced Staff List Case
    Validate Page Content    Google
    Should Not Be Empty    ${title}

Multi-Browser Test
    [Documentation]    Test across multiple browsers
    [Tags]    regression    multi-browser
    
    FOR    ${browser}    IN    @{BROWSERS}
        Log    Testing with browser: ${browser}
        ${title}=    Enhanced Staff List Case    
        ...    browser=${browser}    
        ...    screenshot_name=${browser}_test.png
        Should Not Be Empty    ${title}
        Close Browser
    END

Custom URL Test
    [Documentation]    Test with custom URL
    [Tags]    functional
    [Setup]    Set Test Variable    ${URL}    https://www.example.com
    
    ${title}=    Enhanced Staff List Case    url=${URL}    screenshot_name=example_test.png
    Log    Successfully tested: ${URL}
    [Teardown]    Close Browser

*** Variables ***
@{BROWSERS}    headlesschrome    chrome    firefox
```

### 2. Data-Driven Testing Example

**File:** `data_driven_tests.robot`

```robot
*** Settings ***
Library         SeleniumLibrary
Library         Collections

*** Variables ***
&{TEST_DATA}    google=https://www.google.com
...             example=https://www.example.com
...             github=https://www.github.com

*** Keywords ***
Test Website
    [Documentation]    Generic keyword for testing any website
    [Arguments]    ${site_name}    ${url}    ${expected_content}
    
    Log    Testing ${site_name}: ${url}
    Open Browser    ${url}    headlesschrome
    Maximize Browser Window
    
    Wait Until Page Contains    ${expected_content}    timeout=30s
    ${title}=    Get Title
    Capture Page Screenshot    ${site_name}_test.png
    
    Log    ${site_name} test completed. Title: ${title}
    Close Browser
    
    [Return]    ${title}

*** Test Cases ***
Test Multiple Websites
    [Documentation]    Data-driven test for multiple websites
    [Template]    Test Website
    
    google      https://www.google.com      Google
    example     https://www.example.com     Example Domain
    github      https://www.github.com      GitHub

Dynamic Website Testing
    [Documentation]    Dynamically test websites from dictionary
    
    FOR    ${site_name}    ${url}    IN    &{TEST_DATA}
        ${title}=    Test Website    ${site_name}    ${url}    ${site_name}
        Should Not Be Empty    ${title}
    END
```

## Real-World Scenarios

### 1. E-commerce Website Testing

```robot
*** Settings ***
Library         SeleniumLibrary
Library         String

*** Variables ***
${ECOMMERCE_URL}    https://demo.opencart.com/
${PRODUCT_NAME}     MacBook
${CUSTOMER_EMAIL}   test@example.com

*** Keywords ***
Search For Product
    [Documentation]    Search for a product on e-commerce site
    [Arguments]    ${product_name}
    
    Open Browser    ${ECOMMERCE_URL}    headlesschrome
    Maximize Browser Window
    
    Input Text    name:search    ${product_name}
    Click Button    css:.btn-default
    
    Wait Until Page Contains    ${product_name}
    Capture Page Screenshot    search_results.png

Add Product To Cart
    [Documentation]    Add first product from search results to cart
    
    Click Element    xpath://div[@class='product-thumb'][1]//h4/a
    Wait Until Page Contains    Add to Cart
    Click Button    id:button-cart
    
    Wait Until Page Contains    Success
    Capture Page Screenshot    product_added.png

View Shopping Cart
    [Documentation]    Navigate to shopping cart
    
    Click Element    id:cart
    Click Link    View Cart
    
    Wait Until Page Contains    Shopping Cart
    Capture Page Screenshot    shopping_cart.png

*** Test Cases ***
Complete Shopping Flow
    [Documentation]    End-to-end e-commerce testing
    [Tags]    e2e    shopping
    
    Search For Product    ${PRODUCT_NAME}
    Add Product To Cart
    View Shopping Cart
    
    [Teardown]    Close Browser
```

### 2. Form Submission Testing

```robot
*** Settings ***
Library         SeleniumLibrary
Library         FakerLibrary

*** Keywords ***
Fill Contact Form
    [Documentation]    Fill out a contact form with test data
    [Arguments]    ${form_url}
    
    Open Browser    ${form_url}    headlesschrome
    Maximize Browser Window
    
    # Generate fake data
    ${name}=        FakerLibrary.Name
    ${email}=       FakerLibrary.Email
    ${message}=     FakerLibrary.Text    max_nb_chars=200
    
    # Fill form fields
    Input Text      id:name         ${name}
    Input Text      id:email        ${email}
    Input Text      id:subject      Test Subject
    Input Text      id:message      ${message}
    
    Capture Page Screenshot    form_filled.png
    
    # Submit form
    Click Button    css:button[type="submit"]
    
    # Verify submission
    Wait Until Page Contains    Thank you    timeout=10s
    Capture Page Screenshot    form_submitted.png
    
    [Return]    ${name}    ${email}

*** Test Cases ***
Contact Form Submission
    [Documentation]    Test contact form functionality
    [Tags]    forms    functional
    
    ${name}    ${email}=    Fill Contact Form    https://example.com/contact
    Log    Form submitted by: ${name} (${email})
    
    [Teardown]    Close Browser
```

### 3. API Testing Integration

```robot
*** Settings ***
Library         SeleniumLibrary
Library         RequestsLibrary
Library         Collections

*** Keywords ***
Verify UI Matches API Data
    [Documentation]    Compare UI data with API response
    [Arguments]    ${api_endpoint}    ${ui_url}
    
    # Get data from API
    Create Session    api    ${api_endpoint}
    ${api_response}=    GET On Session    api    /users/1
    ${api_data}=    Set Variable    ${api_response.json()}
    
    # Get data from UI
    Open Browser    ${ui_url}    headlesschrome
    ${ui_name}=    Get Text    id:user-name
    ${ui_email}=    Get Text    id:user-email
    
    # Compare data
    Should Be Equal    ${api_data['name']}    ${ui_name}
    Should Be Equal    ${api_data['email']}    ${ui_email}
    
    Capture Page Screenshot    ui_api_comparison.png
    Close Browser

*** Test Cases ***
UI API Data Consistency
    [Documentation]    Verify UI displays correct API data
    [Tags]    integration    api
    
    Verify UI Matches API Data    
    ...    https://jsonplaceholder.typicode.com    
    ...    https://example.com/user-profile
```

## Integration Patterns

### 1. Page Object Model Implementation

**File:** `page_objects/google_page.robot`

```robot
*** Keywords ***
Google Page Should Be Open
    [Documentation]    Verify Google homepage is loaded
    Title Should Be    Google
    Page Should Contain Element    name:q

Search For Text
    [Documentation]    Perform search on Google
    [Arguments]    ${search_term}
    
    Input Text    name:q    ${search_term}
    Press Keys    name:q    RETURN
    Wait Until Page Contains    results

Get Search Results Count
    [Documentation]    Get number of search results
    ${results}=    Get WebElements    css:.g
    ${count}=    Get Length    ${results}
    [Return]    ${count}
```

**File:** `tests/google_search_tests.robot`

```robot
*** Settings ***
Resource    ../page_objects/google_page.robot

*** Test Cases ***
Google Search Test
    [Documentation]    Test Google search functionality
    
    Open Browser    https://www.google.com    headlesschrome
    Google Page Should Be Open
    
    Search For Text    Robot Framework
    ${count}=    Get Search Results Count
    Should Be True    ${count} > 0
    
    Capture Page Screenshot    search_results.png
    Close Browser
```

### 2. Configuration Management

**File:** `config/environments.robot`

```robot
*** Variables ***
&{DEV_CONFIG}       url=https://dev.example.com
...                 browser=chrome
...                 timeout=30s
...                 delay=1

&{STAGING_CONFIG}   url=https://staging.example.com
...                 browser=headlesschrome
...                 timeout=45s
...                 delay=0.5

&{PROD_CONFIG}      url=https://prod.example.com
...                 browser=headlesschrome
...                 timeout=60s
...                 delay=0

*** Keywords ***
Setup Environment
    [Documentation]    Setup test environment based on configuration
    [Arguments]    ${env_config}
    
    Set Suite Variable    ${URL}          ${env_config.url}
    Set Suite Variable    ${BROWSER}      ${env_config.browser}
    Set Suite Variable    ${TIMEOUT}      ${env_config.timeout}
    Set Suite Variable    ${DELAY}        ${env_config.delay}
    
    Set Selenium Timeout    ${TIMEOUT}
    Set Selenium Speed      ${DELAY}
```

## Testing Strategies

### 1. Smoke Testing Suite

```robot
*** Settings ***
Library         SeleniumLibrary
Suite Setup     Log    Starting smoke tests
Suite Teardown  Log    Smoke tests completed

*** Test Cases ***
Homepage Loads
    [Documentation]    Verify homepage loads successfully
    [Tags]    smoke    critical
    
    Open Browser    ${URL}    ${BROWSER}
    Page Should Contain Element    body
    ${title}=    Get Title
    Should Not Be Empty    ${title}
    Capture Page Screenshot    homepage_smoke.png
    Close Browser

Basic Navigation Works
    [Documentation]    Verify basic navigation functionality
    [Tags]    smoke    navigation
    
    Open Browser    ${URL}    ${BROWSER}
    # Add navigation steps specific to your application
    Capture Page Screenshot    navigation_smoke.png
    Close Browser

Search Functionality Works
    [Documentation]    Verify search works
    [Tags]    smoke    search
    
    staff list case
    # Add search validation steps
```

### 2. Regression Testing Suite

```robot
*** Settings ***
Library         SeleniumLibrary
Test Template   Run Regression Test

*** Keywords ***
Run Regression Test
    [Documentation]    Template for regression tests
    [Arguments]    ${test_name}    ${url}    ${expected_element}
    
    Log    Running regression test: ${test_name}
    Open Browser    ${url}    headlesschrome
    Wait Until Page Contains Element    ${expected_element}    timeout=30s
    Capture Page Screenshot    regression_${test_name}.png
    Close Browser

*** Test Cases ***                TEST_NAME           URL                         EXPECTED_ELEMENT
Homepage Regression             homepage            https://www.google.com      name:q
Search Page Regression          search              https://www.google.com      name:q  
Mobile View Regression          mobile              https://www.google.com      name:q
```

## Performance Optimization Examples

### 1. Parallel Test Execution

```bash
# Run tests in parallel
robot --processes 4 robot_d1.robot

# Run with automatic process detection
robot --processes auto robot_d1.robot

# Parallel execution with custom configuration
robot --processes 2 --outputdir parallel_results robot_d1.robot
```

### 2. Browser Session Reuse

```robot
*** Keywords ***
Shared Browser Session
    [Documentation]    Reuse browser session across tests
    
    ${browser_open}=    Run Keyword And Return Status    Get Window Titles
    Run Keyword Unless    ${browser_open}    
    ...    Open Browser    ${URL}    ${BROWSER}

*** Test Cases ***
Test 1 With Shared Browser
    Shared Browser Session
    Go To    https://www.google.com
    Capture Page Screenshot    test1.png

Test 2 With Shared Browser  
    Shared Browser Session
    Go To    https://www.example.com
    Capture Page Screenshot    test2.png
    
    [Teardown]    Close Browser
```

### 3. Selective Test Execution

```robot
*** Test Cases ***
Quick Test
    [Tags]    quick    smoke
    staff list case

Slow Test
    [Tags]    slow    regression
    staff list case
    Sleep    5s    # Simulate slow operation
```

```bash
# Run only quick tests
robot --include quick robot_d1.robot

# Exclude slow tests
robot --exclude slow robot_d1.robot

# Run specific test combinations
robot --include smokeANDquick robot_d1.robot
```

## Error Handling Patterns

### 1. Retry Mechanisms

```robot
*** Keywords ***
Retry Operation
    [Documentation]    Retry an operation with exponential backoff
    [Arguments]    ${keyword}    ${max_attempts}=3    @{args}
    
    FOR    ${attempt}    IN RANGE    ${max_attempts}
        ${status}=    Run Keyword And Return Status    ${keyword}    @{args}
        Return From Keyword If    ${status}
        
        ${delay}=    Evaluate    2 ** ${attempt}
        Log    Attempt ${attempt + 1} failed, waiting ${delay}s before retry
        Sleep    ${delay}s
    END
    
    Fail    Operation failed after ${max_attempts} attempts

*** Test Cases ***
Robust Web Test
    Retry Operation    staff list case
```

### 2. Graceful Failure Handling

```robot
*** Keywords ***
Safe Web Operation
    [Documentation]    Perform web operation with graceful failure handling
    
    TRY
        staff list case
    EXCEPT    WebDriverException    AS    ${error}
        Log    Browser error occurred: ${error}
        Run Keyword And Ignore Error    Close Browser
        Open Browser    ${URL}    headlesschrome
        staff list case
    EXCEPT    TimeoutException    AS    ${error}
        Log    Timeout error: ${error}
        Capture Page Screenshot    timeout_error.png
        Reload Page
    FINALLY
        Log    Web operation completed
    END
```

## CI/CD Integration

### 1. Jenkins Pipeline Integration

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh 'pip install robotframework robotframework-seleniumlibrary'
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    robot --outputdir results \
                          --variable BROWSER:headlesschrome \
                          --variable URL:${TEST_URL} \
                          robot_d1.robot
                '''
            }
        }
        
        stage('Results') {
            steps {
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'results',
                    reportFiles: 'report.html',
                    reportName: 'Robot Framework Report'
                ])
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'results/**/*', fingerprint: true
        }
    }
}
```

### 2. GitHub Actions Integration

```yaml
name: Robot Framework Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: 3.9
    
    - name: Install dependencies
      run: |
        pip install robotframework robotframework-seleniumlibrary
        sudo apt-get update
        sudo apt-get install -y chromium-chromedriver
    
    - name: Run tests
      run: |
        robot --outputdir results \
              --variable BROWSER:headlesschrome \
              --variable URL:https://www.google.com \
              robot_d1.robot
    
    - name: Upload results
      uses: actions/upload-artifact@v2
      if: always()
      with:
        name: robot-results
        path: results/
```

### 3. Docker Integration

**Dockerfile:**
```dockerfile
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install robotframework robotframework-seleniumlibrary

# Copy test files
COPY . /tests
WORKDIR /tests

# Run tests
CMD ["robot", "--outputdir", "/results", "robot_d1.robot"]
```

**Usage:**
```bash
# Build image
docker build -t robot-tests .

# Run tests
docker run -v $(pwd)/results:/results robot-tests

# Run with custom variables
docker run -v $(pwd)/results:/results \
    robot-tests robot --variable URL:https://example.com robot_d1.robot
```

This comprehensive usage examples document provides practical implementations and patterns for effectively using the Robot Framework test automation project in various real-world scenarios, from basic testing to complex CI/CD integrations.