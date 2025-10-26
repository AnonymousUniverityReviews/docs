# 3. Backend tenancy decision

Date: 2025-10-26

## Status

Accepted

## Context

The project is a platform for students to leave anonymous reviews about their universities and, in later stages, to participate in a social network where they can post anonymously.  
A question was raised whether the backend should be designed as **multi-tenant** (supporting multiple universities as logically separated tenants) or as a **single-tenant** system serving all users within one shared environment.

In a multi-tenant architecture, each tenant (university) would have logically isolated data and possibly its own configuration, while the application codebase and infrastructure remain shared.  
In contrast, a single-tenant architecture stores all data within one logical system, applying tenant-like distinctions (e.g., “university_id” fields) only where needed.


## Decision

We decided to implement a **single-tenant architecture**.

All universities and their users will share the same backend instance and database. Logical separation (via identifiers like `university_id` or `faculty_id`) will be enforced at the data model level, not through physical or service-level isolation.

### Reasons for choosing Single-Tenant

1. **Uniform functionality:** Every university uses the same features and logic; there is no need for tenant-specific customization.  
2. **Simpler design and maintenance:** Avoids the operational overhead of managing multiple schemas, database connections, or isolated environments.  
3. **Faster development:** Reduces configuration, setup, and testing complexity.  
4. **Team experience:** The development team is still small and less experienced with distributed or multi-tenant setups.  
5. **Flexibility for the future:** If the need arises, logical tenant separation can be extended later with minimal schema changes.

## Consequences

### Positive

- **Simpler infrastructure:** One backend, one database, one deployment pipeline.  
- **Easier maintenance:** No need to manage per-tenant migrations, backups, or access controls.  
- **Lower cost:** Fewer instances and simpler hosting requirements.  
- **Faster feature rollout:** All users receive updates simultaneously.

### Negative / Risks

- **Data segregation risk:** Mistakes in data filtering (e.g., missing `university_id` constraints) could expose data from other universities.  
- **Limited scalability per tenant:** Cannot easily allocate resources differently per university.  
- **Future migration cost:** If strict tenant isolation becomes necessary later, refactoring may be required.

### Mitigation Strategies

- Implement **strict tenant-level filtering** in all data access layers.  
- Introduce automated tests to ensure tenant isolation is preserved logically.  
- Keep the code modular and database schema clear enough to support future partitioning or migration toward multi-tenancy if the product grows.
