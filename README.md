# 📦 GitHub Action for Notification Trigger URL — `notification-trigger-url-action`

This GitHub Action sends a notification to a specified URL with details about the status of a pipeline, including vulnerability scan results from Trivy.

## 🔧 Inputs

- **`webhook-url`**: URL to send the notification to.
- **`status`**: Status of the pipeline (e.g., success, failure).
- **`message`**: Main message for the notification.
- **`project`**: Name of the project.
- **`branch`**: Branch name.
- **`repository`**: Repository name.
- **`commit`**: Commit hash.
- **`cloud-provider`**: Cloud provider (e.g., AWS, Azure, GCP).
- **`user`**: User who triggered the action.
- **`build-url`**: URL of the build.

### Optional Inputs - Vulnerability Docker Image Counts
- **`critical-count`**: Number of critical vulnerabilities.
- **`high-count`**: Number of high vulnerabilities.
- **`medium-count`**: Number of medium vulnerabilities.
- **`low-count`**: Number of low vulnerabilities.
- **`unknown-count`**: Number of unknown vulnerabilities.
- **`total-count`**: Total number of vulnerabilities.

## 🚀 How to Use

```yaml
name: Example Notification Trigger

on:
  push:
    branches:
      - main

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: |
          docker build -t myapp:latest .

      - name: Notification Teams
        if: success()
        uses: Tooark/notification-trigger-url-action@v1
        id: notification-teams
        with:
          status: "success"
          message: "Pipeline CI/CD - success"
          project: ${{ github.repository}}
          branch: ${{ github.ref_name }}
          repository: ${{ github.repository }}
          commit: ${{ github.sha }}
          cloud-provider: "AWS"
          user: ${{ github.actor }}
          build-url: "https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
          webhook-url: "https://example.com/webhook"
```

## 🚀 How to Use with Docker Vulnerabilities Report

```yaml
name: Example Notification Trigger with Docker Vulnerabilities Report

on:
  push:
    branches:
      - main

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Notification Teams
        if: success()
        uses: Tooark/notification-trigger-url-action@v1
        id: notification-teams
        with:
          status: "success"
          message: "Pipeline CI/CD - success"
          project: ${{ github.repository}}
          branch: ${{ github.ref_name }}
          repository: ${{ github.repository }}
          commit: ${{ github.sha }}
          cloud-provider: "AWS"
          user: ${{ github.actor }}
          build-url: "https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
          webhook-url: "https://example.com/webhook"
          # Vulnerability Docker Image Counts
          critical-count: ${{ steps.trivy-summary-generator.outputs.critical_count }}
          high-count: ${{ steps.trivy-summary-generator.outputs.high_count }}
          medium-count: ${{ steps.trivy-summary-generator.outputs.medium_count }}
          low-count: ${{ steps.trivy-summary-generator.outputs.low_count }}
          unknown-count: ${{ steps.trivy-summary-generator.outputs.unknown_count }}
          total-count: ${{ steps.trivy-summary-generator.outputs.total_count }}
```

## Contribution

Contributions are welcome! Feel free to open issues and pull requests in the [Notification Trigger Url](https://github.com/Tooark/notification-trigger-url-action/issues) repository.

---

## Contributors

The following users are contributing to the project:

| <img src="https://avatars.githubusercontent.com/u/97809060?v=4" width=120> | 
| :-------------------------------------------------------------------------: |
| [**Stenio Ignacio**](https://github.com/stenioignacio) |
