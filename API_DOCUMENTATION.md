# API Documentation

## Overview

This document provides comprehensive documentation for all public APIs, functions, and components in the Robot Framework test automation project. It includes detailed descriptions, parameters, return values, and usage examples for each component.

## Table of Contents

- [Robot Framework Test Suite API](#robot-framework-test-suite-api)
- [Custom Keywords](#custom-keywords)
- [Variables API](#variables-api)
- [SeleniumLibrary Integration](#seleniumlibrary-integration)
- [Test Cases API](#test-cases-api)
- [Configuration API](#configuration-api)
- [Error Handling](#error-handling)
- [Extension Points](#extension-points)

## Robot Framework Test Suite API

### File: `robot_d1.robot`

**Description:** Main test suite file containing web automation test cases and custom keywords.

**Imports:**
- `SeleniumLibrary` - Web browser automation library

**Public Interface:**
- Variables: `${URL}`, `${BROWSER}`, `${DELAY}`
- Keywords: `staff list case`
- Test Cases: `cc`

## Custom Keywords

### `staff list case`

**Signature:** `staff list case`

**Description:** 
A composite keyword that performs a complete web browser automation workflow including browser initialization, page navigation, window management, speed configuration, and screenshot capture.

**Parameters:** None

**Return Value:** None

**Exceptions:**
- `WebDriverException` - If browser fails to start or navigate
- `TimeoutException` - If page load exceeds timeout
- `PermissionError` - If screenshot cannot be saved

**Implementation Details:**
```robot
staff list case
    Open Browser                ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed          ${DELAY}
    Capture Page Screenshot     custom_name.png
```

**Usage Examples:**

Basic usage:
```robot
*** Test Cases ***
Simple Web Test
    staff list case
```

With custom variables:
```robot
*** Variables ***
${CUSTOM_URL}    https://example.com
${CUSTOM_BROWSER}    chrome

*** Test Cases ***
Custom Web Test
    Set Test Variable    ${URL}    ${CUSTOM_URL}
    Set Test Variable    ${BROWSER}    ${CUSTOM_BROWSER}
    staff list case
```

With error handling:
```robot
*** Test Cases ***
Robust Web Test
    Run Keyword And Continue On Failure    staff list case
    Run Keyword If Test Failed    Log    Test failed but continuing
```

**Dependencies:**
- SeleniumLibrary
- Valid browser driver (ChromeDriver, GeckoDriver, etc.)
- Network connectivity to target URL

**Performance Characteristics:**
- Execution time: 3-10 seconds (network dependent)
- Memory usage: ~50-100MB (browser dependent)
- CPU usage: Low to moderate during execution

## Variables API

### Global Variables

#### `${URL}`

**Type:** String
**Default Value:** `https://www.google.co.th/`
**Description:** Target URL for web automation tests
**Scope:** Test Suite
**Modifiable:** Yes (via command line or test setup)

**Usage:**
```robot
# Command line override
robot --variable URL:https://example.com robot_d1.robot

# In test case
Set Test Variable    ${URL}    https://custom-site.com
```

#### `${BROWSER}`

**Type:** String
**Default Value:** `headlesschrome`
**Description:** Browser type for test execution
**Scope:** Test Suite
**Modifiable:** Yes

**Valid Values:**
- `headlesschrome` - Chrome in headless mode
- `chrome` - Chrome with GUI
- `firefox` - Firefox browser
- `edge` - Microsoft Edge
- `safari` - Safari browser (macOS only)

**Usage:**
```robot
# Command line override
robot --variable BROWSER:firefox robot_d1.robot

# In test case
Set Suite Variable    ${BROWSER}    chrome
```

#### `${DELAY}`

**Type:** String/Number
**Default Value:** `0`
**Description:** Selenium execution delay in seconds
**Scope:** Test Suite
**Modifiable:** Yes

**Usage:**
```robot
# Command line override
robot --variable DELAY:2 robot_d1.robot

# In test case
Set Test Variable    ${DELAY}    1.5
```

## SeleniumLibrary Integration

### Browser Management APIs

#### `Open Browser`

**Signature:** `Open Browser    url    browser    alias=None    remote_url=False    desired_capabilities=None    ff_profile_dir=None    options=None    service_log_path=None    executable_path=None`

**Description:** Opens a new browser instance and navigates to the specified URL.

**Parameters:**
- `url` (string): Target URL to navigate to
- `browser` (string): Browser type (chrome, firefox, edge, safari)
- `alias` (string, optional): Browser alias for multiple browser handling
- `remote_url` (string, optional): Remote WebDriver URL for grid execution
- `desired_capabilities` (dict, optional): Browser-specific capabilities
- `ff_profile_dir` (string, optional): Firefox profile directory
- `options` (object, optional): Browser-specific options
- `service_log_path` (string, optional): WebDriver service log path
- `executable_path` (string, optional): Custom driver executable path

**Return Value:** Browser index (integer)

**Example Usage:**
```robot
# Basic usage
Open Browser    https://example.com    chrome

# With alias
Open Browser    https://example.com    chrome    alias=main_browser

# With options
${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
Call Method    ${chrome_options}    add_argument    --disable-web-security
Open Browser    https://example.com    chrome    options=${chrome_options}
```

#### `Maximize Browser Window`

**Signature:** `Maximize Browser Window`

**Description:** Maximizes the current browser window to fill the screen.

**Parameters:** None

**Return Value:** None

**Example Usage:**
```robot
Open Browser    https://example.com    chrome
Maximize Browser Window
```

#### `Set Selenium Speed`

**Signature:** `Set Selenium Speed    delay`

**Description:** Sets the delay between Selenium commands.

**Parameters:**
- `delay` (string/number): Delay in seconds (can be decimal)

**Return Value:** None

**Example Usage:**
```robot
# Set 2-second delay
Set Selenium Speed    2

# Set half-second delay
Set Selenium Speed    0.5

# No delay (fastest execution)
Set Selenium Speed    0
```

#### `Capture Page Screenshot`

**Signature:** `Capture Page Screenshot    filename=screenshot-{index}.png`

**Description:** Takes a screenshot of the current page and saves it to a file.

**Parameters:**
- `filename` (string, optional): Output filename (supports path and timestamp placeholders)

**Return Value:** Path to saved screenshot file

**Example Usage:**
```robot
# Default filename
Capture Page Screenshot

# Custom filename
Capture Page Screenshot    my_test_screenshot.png

# With timestamp
Capture Page Screenshot    test_{index}_{timestamp}.png

# With full path
Capture Page Screenshot    /tmp/screenshots/page_capture.png
```

#### `Close Browser`

**Signature:** `Close Browser`

**Description:** Closes the current browser instance.

**Parameters:** None

**Return Value:** None

**Example Usage:**
```robot
Open Browser    https://example.com    chrome
# ... test operations ...
Close Browser
```

## Test Cases API

### Test Case: `cc`

**Description:** Primary test case that demonstrates basic web automation workflow.

**Test Data:** Uses global variables (`${URL}`, `${BROWSER}`, `${DELAY}`)

**Test Steps:**
1. Execute `staff list case` keyword
2. Leave browser open for inspection (Close Browser commented out)

**Expected Results:**
- Browser opens successfully
- Page loads without errors
- Screenshot is captured
- Test passes without exceptions

**Execution Context:**
- Suite: robot_d1.robot
- Tags: None (can be added)
- Setup: None
- Teardown: None (browser remains open)

**Usage Examples:**

Run specific test:
```bash
robot --test cc robot_d1.robot
```

Run with tags:
```robot
*** Test Cases ***
cc    [Tags]    smoke    regression
    staff list case
```

With setup and teardown:
```robot
*** Test Cases ***
cc
    [Setup]    Log    Starting test case
    staff list case
    [Teardown]    Close Browser
```

## Configuration API

### Command Line Interface

The test suite supports various command-line options for configuration:

#### Variable Override
```bash
# Single variable
robot --variable URL:https://example.com robot_d1.robot

# Multiple variables
robot --variable URL:https://example.com --variable BROWSER:firefox robot_d1.robot
```

#### Output Configuration
```bash
# Custom output directory
robot --outputdir results robot_d1.robot

# Custom report names
robot --report custom_report.html --log custom_log.html robot_d1.robot
```

#### Execution Control
```bash
# Include/exclude by tags
robot --include smoke robot_d1.robot
robot --exclude slow robot_d1.robot

# Specific test cases
robot --test cc robot_d1.robot

# Parallel execution
robot --processes 4 robot_d1.robot
```

#### Logging and Debugging
```bash
# Debug mode
robot --loglevel DEBUG robot_d1.robot

# Console output
robot --console verbose robot_d1.robot

# Debug file
robot --debugfile debug.log robot_d1.robot
```

## Error Handling

### Common Exceptions

#### `WebDriverException`
**Cause:** Browser driver issues, network problems, or invalid configurations
**Handling:**
```robot
*** Keywords ***
Safe Browser Open
    Run Keyword And Return Status    Open Browser    ${URL}    ${BROWSER}
    Run Keyword If    '${KEYWORD STATUS}' == 'FAIL'    
    ...    Log    Failed to open browser, trying alternative
    ...    AND    Open Browser    ${URL}    headlesschrome
```

#### `TimeoutException`
**Cause:** Page load timeout or element not found within timeout period
**Handling:**
```robot
*** Keywords ***
Robust Page Load
    Set Selenium Timeout    30 seconds
    Run Keyword And Continue On Failure    Open Browser    ${URL}    ${BROWSER}
```

#### `PermissionError`
**Cause:** Insufficient permissions to write screenshot files
**Handling:**
```robot
*** Keywords ***
Safe Screenshot
    Run Keyword And Ignore Error    Capture Page Screenshot    ${SCREENSHOT_NAME}
    Run Keyword If    '${KEYWORD STATUS}' == 'FAIL'    
    ...    Log    Screenshot failed, continuing test
```

### Error Recovery Patterns

```robot
*** Keywords ***
Resilient Web Test
    [Documentation]    Web test with error recovery
    FOR    ${attempt}    IN RANGE    3
        ${status}=    Run Keyword And Return Status    staff list case
        Exit For Loop If    ${status}
        Log    Attempt ${attempt + 1} failed, retrying...
        Sleep    2s
    END
    Should Be True    ${status}    All attempts failed
```

## Extension Points

### Custom Keywords

You can extend the test suite by adding custom keywords:

```robot
*** Keywords ***
Enhanced Staff List Case
    [Documentation]    Extended version with additional checks
    [Arguments]    ${custom_url}=None    ${timeout}=30s
    
    Set Selenium Timeout    ${timeout}
    Run Keyword If    '${custom_url}' != 'None'    
    ...    Set Test Variable    ${URL}    ${custom_url}
    
    staff list case
    
    # Additional validations
    Page Should Contain    Google
    Title Should Contain    Google
```

### Variable Files

Create external variable files for different environments:

```python
# variables/dev.py
URL = "https://dev.example.com"
BROWSER = "chrome"
DELAY = 1

# variables/prod.py  
URL = "https://prod.example.com"
BROWSER = "headlesschrome"
DELAY = 0
```

Usage:
```bash
robot --variablefile variables/dev.py robot_d1.robot
```

### Resource Files

Create reusable keyword libraries:

```robot
# resources/common.robot
*** Keywords ***
Setup Test Environment
    Set Selenium Speed    ${DELAY}
    Set Selenium Timeout    30s
    
Cleanup Test Environment
    Close All Browsers
    Remove Files    *.png
```

Import in main test:
```robot
*** Settings ***
Resource    resources/common.robot

*** Test Cases ***
Enhanced Test
    [Setup]    Setup Test Environment
    staff list case
    [Teardown]    Cleanup Test Environment
```

### Listeners and Libraries

Create custom Python libraries for advanced functionality:

```python
# CustomLibrary.py
from robot.api import logger
from datetime import datetime

class CustomLibrary:
    def log_with_timestamp(self, message):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logger.info(f"[{timestamp}] {message}")
        
    def get_screenshot_name(self):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        return f"screenshot_{timestamp}.png"
```

Usage:
```robot
*** Settings ***
Library    CustomLibrary.py

*** Test Cases ***
Enhanced Test With Custom Library
    Log With Timestamp    Starting test case
    ${screenshot_name}=    Get Screenshot Name
    Open Browser    ${URL}    ${BROWSER}
    Capture Page Screenshot    ${screenshot_name}
```

## Performance Considerations

### Optimization Strategies

1. **Browser Reuse:**
```robot
*** Keywords ***
Reusable Browser Session
    [Documentation]    Reuse browser across multiple tests
    ${browser_open}=    Run Keyword And Return Status    Get Window Titles
    Run Keyword Unless    ${browser_open}    Open Browser    ${URL}    ${BROWSER}
```

2. **Parallel Execution:**
```bash
robot --processes auto robot_d1.robot
```

3. **Selective Test Execution:**
```robot
*** Test Cases ***
Quick Smoke Test    [Tags]    smoke
    staff list case

Full Regression Test    [Tags]    regression
    staff list case
    # Additional comprehensive tests
```

4. **Resource Management:**
```robot
*** Keywords ***
Efficient Screenshot
    [Arguments]    ${condition}=True
    Run Keyword If    ${condition}    Capture Page Screenshot
```

This API documentation provides a comprehensive reference for all public interfaces, functions, and components in the Robot Framework test automation project, including detailed usage examples and best practices for extension and optimization.