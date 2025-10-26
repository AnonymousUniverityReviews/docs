# 4. Backend auth decision

Date: 2025-10-26

## Status

Accepted

## Context

The project requires an authentication mechanism that guarantees user anonymity and privacy while still allowing secure verification of university-affiliated accounts.

During registration, a user enters their **university email** and **password**. A confirmation letter is sent to the provided email address.  
Immediately after submission — **before any verification occurs** — both the email and password are **securely hashed and stored in the database**.  
A boolean flag indicates whether the email has been confirmed, but the plaintext email address is **never persisted** or logged at any point in the process.

This privacy-by-design approach ensures that even if the database is compromised, no personal email data can be reconstructed.  
Because of this strict requirement, we **cannot use standard authentication frameworks** like **ASP.NET Identity**, **Keycloak**, or other common OAuth providers, as they all store emails or usernames in plaintext form.

Therefore, we needed an authentication solution that:
- Allows full control over user storage and data handling.  
- Supports secure OAuth 2.1 and OpenID Connect flows.  
- Includes essential features like token management, refresh tokens, and standards compliance.

## Decision

We decided to implement a **custom OpenID Connect provider** using the **OpenIddict** library for ASP.NET.

OpenIddict enables us to act as our own authorization server while remaining compliant with OAuth 2.1 and OpenID Connect specifications.  
It allows us to fully customize user persistence (including hashing logic) while leveraging a mature and secure token management system.

### Design Overview

- **Provider:** OpenIddict-based authorization server embedded in the backend.  
- **Client:** The Nuxt.js frontend (first-party SPA).  
- **Flow:** Authorization Code Flow with PKCE (Proof Key for Code Exchange).  
- **User data:** University email and password are both hashed immediately upon registration; only a confirmation flag is stored in plain form.  
- **Tokens:** Access and refresh tokens are JWT-based and handled by OpenIddict.  
- **Future support:** The provider can later expose a Client Credentials Flow for third-party or public APIs.

### Reasons for choosing OpenIddict

1. **Full data control:** We can completely customize the identity model and hashing process, ensuring no plaintext email ever exists in storage.  
2. **Security compliance:** Supports secure, modern authentication standards (OAuth 2.1, OpenID Connect) including PKCE and refresh tokens.  
3. **Extensible architecture:** Can easily add more flows (e.g., Client Credentials, Device Code) in the future.  
4. **First-party integration:** Perfect fit for a single SPA frontend communicating directly with the backend.  
5. **Out-of-the-box reliability:** Handles JWT creation, validation, and expiration securely without custom cryptographic logic.  
6. **Future readiness:** The same provider can later serve a mobile app or API clients with minimal configuration changes.

## Consequences

### Positive

- **No plaintext personal data:** Both email and password are hashed before storage, guaranteeing strong privacy protection.  
- **Secure and standard-compliant:** OAuth 2.1 + OpenID Connect flows (with PKCE) ensure safe authentication for web and mobile clients.  
- **Extensible and future-proof:** Adding new flows or clients (e.g., public API, mobile app) requires minimal effort.  
- **Full ownership:** We control user data handling, token issuance, and all privacy-related logic.  
- **Reduced vendor lock-in:** The system is independent of external identity providers or third-party services.

### Negative / Risks

- **Higher implementation complexity:** Building and maintaining a custom identity provider requires careful security design and review.  
- **Maintenance responsibility:** Security updates, audits, and flow compliance checks depend entirely on our team.  
- **Smaller ecosystem:** OpenIddict has fewer public examples compared to mainstream providers like Keycloak.

### Mitigation Strategies

- Follow official OpenIddict documentation and OWASP guidelines for secure token management.  
- Conduct regular code reviews and security audits on authentication components.  
- Use modular design so that the provider can later be replaced or extended if project scale demands.
