# ADR 005: Backend Pull Request Review Process

**Date:** 2025-11-05  
**Status:** Accepted

## Context
To maintain high code quality, consistent architecture, and stable delivery in the backend codebase, this ADR defines a standardized pull request (PR) review process.  
It establishes approval requirements, review criteria, and expectations for reviewers and contributors.

## Decision

### Approval Requirements
- **Minimum: 2 approvals** before merging into `main`
  - Preferably one from a mentor/senior or designated reviewer.
- **Exception:** Trivial changes (README, typos, comments, CI config) may be merged with **1 approval**, only if no application-logic code is touched.

### Review Checklist

#### Code Quality
- Code follows project style and conventions
- Clean, readable, clear naming
- No debug artifacts or dead code

#### Architecture & Design
- Respects project architecture and domain boundaries
- Proper layering & separation of concerns
- API and schema changes are documented and justified

#### Correctness & Logic
- Business logic matches requirements
- Edge cases handled
- Proper error handling & logging

#### Tests
- New logic has appropriate test coverage
- All tests pass in CI
- Existing tests not broken without justification

#### Security
- No secrets committed
- Input validation & sensitive data handling
- No obvious vulnerabilities introduced

#### Performance
- No unnecessary heavy operations
- Database queries efficient and reasonable

#### Documentation
- PR description includes purpose, context, and testing steps
- Comments added where needed
- Related docs updated (API specification, ADRs, README, etc.)

### Standard Rules
- Clear PR title + meaningful description
- PR must be focused and reasonably small
- Author must run tests before submission
- Reviewers respond within **1 business day**
- "Request changes" for blocking issues; discussions must be resolved
- Author merges after approvals (not reviewer)
- No force-merging unless approved by lead/mentor in exceptional cases

## Consequences

### Benefits
- Higher code quality and maintainability
- Shared understanding and knowledge
- Consistent architectural decisions
- Reduced onboarding friction

### Trade-offs & Risks
- Review process adds time before merge
- Requires team discipline and collaboration
- Occasional conflict resolution effort needed

### Mitigations
- Keep PRs small and focused
- Adjust review rules over time if needed
- Use pair programming for complex changes to reduce review overhead
