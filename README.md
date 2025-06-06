# Invalid LinuxFxVersion

This repository was created to reproduce an issue encountered after upgrading deprecated Terraform `azurerm` resources to the latest versions, which resulted in an `The parameter LinuxFxVersion has an invalid value.` error when deploying an Azure Function App.

## Problem Background

- The project started with the older, now-deprecated resource `azurerm_function_app`, which originally created the Azure Function as a **Windows** app.
- When attempting to fix the deprecated resource warning, the migration was mistakenly done to a **Linux** resource (`azurerm_linux_function_app`) instead of the correct Windows resource (`azurerm_windows_function_app`).
- This mismatch caused the error: `The parameter LinuxFxVersion has an invalid value.` during deployment, because the existing Function App was still a Windows app in Azure, but Terraform tried to manage it as a Linux app.

## Reference Pull Requests

- **PR #2**: Introduced the changes that caused the `The parameter LinuxFxVersion has an invalid value.` error. (#2)
- **PR #4**: Provides the solution and fix for the issue. (#4)
