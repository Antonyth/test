# Robot Framework Test Automation Project

## Overview

This project contains automated test cases built using Robot Framework with SeleniumLibrary for web browser automation. The test suite is designed to perform web testing operations including browser automation, screenshot capture, and page interaction.

## Table of Contents

- [Installation](#installation)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Keywords Documentation](#keywords-documentation)
- [Test Cases Documentation](#test-cases-documentation)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Installation

### Prerequisites

- Python 3.7 or higher
- pip package manager

### Required Dependencies

```bash
pip install robotframework
pip install robotframework-seleniumlibrary
```

### Browser Drivers

For Chrome/Chromium browsers:
```bash
# Install ChromeDriver (Linux/macOS)
# Option 1: Using package manager
sudo apt-get install chromium-chromedriver  # Ubuntu/Debian
brew install chromedriver                   # macOS

# Option 2: Download manually from https://chromedriver.chromium.org/
```

## Project Structure

```
.
├── README.md           # Project documentation
└── robot_d1.robot     # Main test suite file
```

## Configuration

### Variables

The test suite uses the following configurable variables:

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `${URL}` | `https://www.google.co.th/` | Target URL for testing |
| `${BROWSER}` | `headlesschrome` | Browser type for test execution |
| `${DELAY}` | `0` | Selenium execution delay in seconds |

### Browser Options

Available browser configurations:
- `headlesschrome` - Chrome in headless mode (default)
- `chrome` - Chrome with GUI (commented out)
- `firefox` - Firefox browser
- `edge` - Microsoft Edge browser

## Keywords Documentation

### Custom Keywords

#### `staff list case`

**Description:** A comprehensive keyword that performs browser setup, navigation, and screenshot capture.

**Parameters:** None

**Returns:** None

**Usage:**
```robot
staff list case
```

**Implementation Details:**
- Opens browser with configured URL and browser type
- Maximizes browser window for consistent viewport
- Sets Selenium execution speed
- Captures page screenshot with custom filename

**Dependencies:**
- SeleniumLibrary

**Example:**
```robot
*** Test Cases ***
Basic Web Test
    staff list case
```

## Test Cases Documentation

### Test Case: `cc`

**Description:** Main test case that executes the staff list workflow.

**Test Steps:**
1. Execute `staff list case` keyword
2. Browser remains open for further inspection (Close Browser is commented out)

**Expected Results:**
- Browser opens successfully
- Page loads completely
- Screenshot is captured as `custom_name.png`

**Test Data:** Uses default variable values

**Execution Time:** ~5-10 seconds (depending on network and system performance)

## Usage Examples

### Basic Execution

Run all test cases:
```bash
robot robot_d1.robot
```

### Advanced Execution Options

Run with custom browser:
```bash
robot --variable BROWSER:chrome robot_d1.robot
```

Run with custom URL:
```bash
robot --variable URL:https://example.com robot_d1.robot
```

Run with execution delay:
```bash
robot --variable DELAY:2 robot_d1.robot
```

Run with custom output directory:
```bash
robot --outputdir results robot_d1.robot
```

Run with specific log level:
```bash
robot --loglevel DEBUG robot_d1.robot
```

### Headless vs GUI Mode

For CI/CD environments (headless):
```bash
robot --variable BROWSER:headlesschrome robot_d1.robot
```

For debugging (with GUI):
```bash
robot --variable BROWSER:chrome robot_d1.robot
```

## API Reference

### SeleniumLibrary Keywords Used

#### `Open Browser`
- **Syntax:** `Open Browser    url    browser`
- **Purpose:** Opens a new browser instance
- **Parameters:**
  - `url`: Target website URL
  - `browser`: Browser type (chrome, firefox, etc.)

#### `Maximize Browser Window`
- **Syntax:** `Maximize Browser Window`
- **Purpose:** Maximizes the browser window
- **Parameters:** None

#### `Set Selenium Speed`
- **Syntax:** `Set Selenium Speed    delay`
- **Purpose:** Sets delay between Selenium commands
- **Parameters:**
  - `delay`: Delay in seconds (string or number)

#### `Capture Page Screenshot`
- **Syntax:** `Capture Page Screenshot    filename`
- **Purpose:** Takes a screenshot of current page
- **Parameters:**
  - `filename`: Output filename for screenshot

#### `Close Browser`
- **Syntax:** `Close Browser`
- **Purpose:** Closes the current browser instance
- **Parameters:** None
- **Note:** Currently commented out in the test

## Best Practices

### 1. Variable Management
- Use variables for configurable values (URLs, timeouts, etc.)
- Keep environment-specific variables in separate files
- Use meaningful variable names

### 2. Keyword Design
- Create reusable keywords for common operations
- Use descriptive keyword names
- Document keyword parameters and return values

### 3. Test Case Structure
- Follow Given-When-Then pattern where applicable
- Use meaningful test case names
- Include proper test documentation

### 4. Browser Management
- Always close browsers after tests (uncomment Close Browser)
- Use headless mode for CI/CD environments
- Handle browser timeouts appropriately

### 5. Screenshot Management
- Use descriptive screenshot names
- Organize screenshots in dedicated folders
- Capture screenshots at key test points

## Troubleshooting

### Common Issues

#### Browser Driver Issues
```
WebDriverException: 'chromedriver' executable needs to be in PATH
```
**Solution:** Install ChromeDriver and ensure it's in system PATH

#### Timeout Issues
```
TimeoutException: Message: timeout
```
**Solution:** Increase implicit wait or add explicit waits

#### Screenshot Permissions
```
PermissionError: [Errno 13] Permission denied: 'custom_name.png'
```
**Solution:** Ensure write permissions in output directory

### Debug Mode

Enable debug logging:
```bash
robot --loglevel DEBUG --debugfile debug.log robot_d1.robot
```

### Performance Optimization

For faster execution:
- Use headless browser mode
- Reduce unnecessary delays
- Optimize element locators
- Use parallel execution for multiple tests

## Contributing

When adding new test cases or keywords:

1. Follow existing naming conventions
2. Add proper documentation
3. Include usage examples
4. Test in both headless and GUI modes
5. Update this README with new functionality

## Output Files

After execution, the following files are generated:

- `log.html` - Detailed test execution log
- `report.html` - Test execution report
- `output.xml` - Test results in XML format
- `custom_name.png` - Screenshot captured during test
- `selenium-screenshot-*.png` - Additional screenshots (if any failures occur)

## Version History

- **v1.0** - Initial test suite with basic browser automation
  - Google.co.th navigation test
  - Screenshot capture functionality
  - Headless Chrome support