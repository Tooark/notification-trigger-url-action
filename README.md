# 📦 GitHub Action for Notification Trigger URL — `notification-trigger-url-action`

This GitHub Action sends a notification to a specified URL with details about the status of a pipeline, including vulnerability scan results from Trivy.

## 🔧 Inputs

- **`status`**: Status of the pipeline (e.g., success, failure).
- **`message`**: Main message for the notification.
- **`project`**: Name of the project.
- **`branch`**: Branch name.
- **`repository`**: Repository name.
- **`commit`**: Commit hash.
- **`cloud-provider`**: Cloud provider (e.g., AWS, Azure, GCP).
- **`user`**: User who triggered the action.
- **`build-url`**: URL of the build.
- **`critical-count`**: Number of critical vulnerabilities.
- **`high-count`**: Number of high vulnerabilities.
- **`medium-count`**: Number of medium vulnerabilities.
- **`low-count`**: Number of low vulnerabilities.
- **`unknown-count`**: Number of unknown vulnerabilities.
- **`total-count`**: Total number of vulnerabilities.
- **`webhook-url`**: URL to send the notification to.

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

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@0.28.0
        with:
          image-ref: 'myapp:latest'
          format: 'json'
          exit-code: '0'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH,MEDIUM,LOW'
          output: 'trivy-results.json'

      - name: Generate Trivy Summary
        uses: Tooark/trivy-summary-action@v1
        id: trivy-summary-generator
        with:
          trivy-json: trivy-results.json
          docker-image: myapp:latest

      - name: Send Notification
        uses: Tooark/notification-trigger-url-action@v1
        id: notification-trigger
        with:
          status: ${{ job.status }}
          message: 'Success - CI/CD Pipeline Notification'
          project: 'myproject'
          branch: 'main'
          repository: 'myorg/myapp'
          commit: ${{ github.sha }}
          cloud-provider: 'AWS'
          user: ${{ github.actor }}
          build-url: ${{ github.run_url }}
          webhook-url: ${{ secrets.WEBHOOK_URL }}
```