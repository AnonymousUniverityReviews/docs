# 7. Backend Unit Testing Framework

**Date:** 2025-11-05  
**Status:** Accepted

## Context
We need a consistent and reliable unit testing framework for the backend to ensure maintainable and high-quality code.  
Both **xUnit** and **NUnit** are popular testing frameworks in the .NET ecosystem, and both provide comprehensive testing features.

Key considerations included:
- Learning curve and developer familiarity
- Ecosystem adoption and community support
- Integration with modern .NET tooling
- Async testing ergonomics
- Attribute-based configuration model
- Best practices alignment for ASP.NET Core applications

Microsoft officially uses and recommends **xUnit** in ASP.NET Core documentation and templates.

## Decision
We will use **xUnit** as the primary unit testing framework for the backend.

### Why xUnit was chosen over NUnit
| Criterion | xUnit | NUnit |
|----------|-------|------|
Recommended in ASP.NET Core docs | ✅ Yes | ❌ No |
Async testing support | ✅ Native | ✅ Good |
Modern .NET philosophy (constructor injection, minimal attributes) | ✅ Yes | ⚠️ Traditional attribute model |
Community adoption in .NET Core era | ✅ Very high | ✅ High |
Test discovery & runner support | ✅ Excellent | ✅ Excellent |
Learning curve | ✅ Easy | ✅ Easy |

### Additional Benefits of xUnit
- Encourages **better test isolation** (no `[SetUp]`/`[TearDown]`; uses constructor + `IDisposable`)
- More idiomatic for **dependency injection** in tests
- Strong integration with:
  - GitHub Actions
  - Coverlet
  - Test adapters for IDEs/editors
- Clean, modern attribute model (e.g., `[Fact]`, `[Theory]`)

### Tooling
- `xunit` NuGet package
- `xunit.runner.visualstudio`
- `coverlet.collector`

## Consequences

### Benefits
- Aligns with ASP.NET Core ecosystem and Microsoft documentation
- Minimal configuration required; works out-of-the-box
- Great community support and modern patterns
- Easier onboarding for new developers familiar with modern .NET learning materials
- Strong support for parallel test execution and async tests

### Trade-offs / Risks
- Developers familiar with NUnit attributes may need slight adjustment
- Fewer built-in assertion helpers vs NUnit (but addressed via FluentAssertions)

### Mitigation
- Use **FluentAssertions** for rich, readable assertions
- Provide internal testing guidelines and examples for consistency
- If future requirements demand NUnit-specific features, migration is feasible because test logic stays similar
