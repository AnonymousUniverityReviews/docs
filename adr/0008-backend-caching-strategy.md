# 8. Backend Caching Strategy

**Date:** 2025-11-05  
**Status:** Accepted

## Context
The backend needs a caching strategy to improve performance and reduce load on external services and the database, while avoiding cache-related reliability issues and stale data risks.

This project includes:
- Anonymous student accounts
- Corporate university email validation
- Viewing and posting student reviews

Caching must be selective. Aggressively caching all data may lead to:
- Cold-start performance issues
- Stale data bugs, especially for authentication-related flows
- Difficult to debug state issues in distributed environments

Therefore, we must identify **safe, low-volatility data** that benefits from caching, and avoid caching sensitive, rapidly-changing, or user-specific information.

## Decision

### We will cache the following:

#### University corporate email domain list
- Rarely changes
- Used frequently during registration
- Reduces DB or external config lookups

TTL: **24 hours**, refreshed manually if the domain list changes

#### Public metadata
Examples (as the platform grows):
- Universities / faculties list
- Courses list
- Static configuration data (e.g., review categories, predefined tags)

TTL: **12–24 hours**, refresh on admin update events if available

#### Common public browse queries (if needed later)
- Popular reviews
- Top rated courses/teachers lists
- Trending tags

TTL: **5–15 minutes** (eventually, if analytics endpoints grow)

> **Note:** These items are non-personal and safe to serve stale briefly.

---

### We will *not* cache:

- Authentication tokens or login data  
- User session or identity data (anonymous or not)
- User-specific pages (e.g., “my profile”, notifications)
- Review submission or editing operations
- Any data that changes frequently or could expose private identity patterns

Rationale:
- High security/PII risk
- State consistency required
- Prevent “ghost user” or stale auth issues

---

### Cache Backend
- In-memory cache for low-cost, local, single-instance caching
- Redis optional for scale-out phase (future ADR)

---

### Cache Invalidation
- TTL-based expiration
- Manual refresh endpoint/internal trigger for domain list updates if required
- “Cache only what’s okay to be slightly stale”

---

## Consequences

### Benefits
- Improved performance on frequent, safe lookups
- Reduced database load for static metadata
- Predictable behavior with low cache complexity
- Avoids risky over-caching of identity-sensitive flows
- Simple invalidation model

### Risks / Trade-offs
- Not caching user-specific or volatile content means some queries may still hit DB frequently
- Domain list changes require invalidation triggers or manual refresh

### Mitigation
- Expand caching incrementally if performance bottlenecks appear
- Consider Redis when scaling to multiple backend instances
- Add monitoring around cache hit/miss rates

