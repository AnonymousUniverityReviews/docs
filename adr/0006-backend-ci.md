# 6. Backend CI

**Date:** 2025-11-05  
**Status:** Accepted

## Context
To ensure high-quality, consistent, and reliable delivery of the backend system, we need a standardized Continuous Integration (CI) process.  
The backend uses **C#, ASP.NET, and xUnit**, and runs on **GitHub**.  
The CI pipeline must enforce code correctness, formatting, testing, and security checks before code can be merged.  

This ADR defines the required steps and tools for the CI pipeline to support code quality, team collaboration, and long-term maintainability.

## Decision

### CI Pipeline Requirements

The CI workflow for the backend will include the following stages:

1. **Environment Setup**
   - Check out repository
   - Install .NET SDK version defined in `global.json` (if present)
   - Restore NuGet packages
   - Cache dependencies for faster builds

2. **Build**
   - `dotnet build --configuration Release --no-restore`

3. **Formatting & Style**
   - Enforce `.editorconfig`
   - Run code formatting check:
     ```sh
     dotnet format --verify-no-changes
     ```

4. **Static Code Analysis**
   - Use built-in Roslyn analyzers with:
     ```xml
     <AnalysisLevel>latest</AnalysisLevel>
     <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
     ```
   - Integrate **SonarQube/SonarCloud** for deeper analysis (bugs, smells, duplication, maintainability, security hotspots)
   - Quality gate must pass before merge

5. **Testing**
   - Execute xUnit tests:
     ```sh
     dotnet test --no-build --collect:"XPlat Code Coverage"
     ```
   - Use Coverlet for coverage and ReportGenerator to publish results

6. **Security & Dependency Checks**
   - GitHub Dependabot for dependency scanning & updates
   - GitHub Secret Scanning enabled
   - Optionally run:
     ```sh
     dotnet list package --vulnerable
     ```

7. **Merge Rules**
   - CI must pass before merge
   - Minimum **2 reviewer approvals** required (per ADR #5)

### Additional Optional Items (Future)
- Validate EF Core migrations
- Build Docker image for backend services
- Deploy to staging environment on protected branch

## Consequences

### Benefits
- Ensures consistent code quality and formatting
- Prevents regressions with automated testing
- Enforces security best practices via dependency and secret scans
- SonarQube provides visibility into code health, debt, and maintainability
- Faster developer onboarding due to predictable standards
- Builds trust in the stability of main branch

### Trade-offs / Risks
- CI pipeline increases build time and complexity
- Developers must fix style/analysis warnings before merging
- SonarQube integration adds configuration overhead

### Mitigation
- Cache dependencies to minimize CI runtime
- Keep `.editorconfig` and analyzer rules reasonable to avoid “noise”
- Adjust rules over time as the codebase grows
- Introduce optional steps gradually (e.g., migration checks later)
