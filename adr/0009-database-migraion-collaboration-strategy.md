# 9. Database Migration Collaboration Strategy

**Date:** 2025-11-05

## Status  
Accepted

## Context  

The project uses EF Core migrations to manage database schema changes.  
Multiple contributors will be working on features that require schema updates.

Without a defined workflow, the following issues may occur:

- Migration file merge conflicts  
- ModelSnapshot conflicts  
- Duplicate or conflicting migrations  
- Unintentionally overwriting another developer's schema change  
- Local environments breaking due to mismatched migration order  

A consistent migration collaboration strategy is required to maintain database integrity and developer productivity.

## Decision  

We will follow a structured process for creating, applying, and merging EF Core migrations in a team environment.

### Workflow Rules

#### Before creating a migration
- Pull the latest changes from the `main` branch.
- Ensure all existing migrations apply cleanly to your local database.

#### Creating migrations
#### Reviewing generated migrations
- Always review generated migration code before committing.
- Ensure EF did not interpret a simple rename as a drop-and-create operation.
- If EF generates destructive operations (e.g., dropping a column/table), update the model or write a custom migration to preserve data.
- Use `RenameColumn`/`RenameTable` operations manually when EF does not detect renames correctly.

- Each feature that modifies data models **must** include its own migration(s).
- Use descriptive migration names (e.g., `AddFacultyFieldToUser`).
- Do not alter other developers' migration files.
- Do not modify old migrations already merged into `main`.

#### Committing migrations
- Commit both the migration files and the updated `ModelSnapshot` file.
- Do not manually edit the snapshot file unless resolving merge conflicts.

#### Handling migration conflicts
If a migration or snapshot conflict occurs:

1. Remove the local migration:
   ```
   dotnet ef migrations remove
   ```
2. Pull changes and resolve code conflicts.
3. Recreate the migration:
   ```
   dotnet ef migrations add <MigrationName>
   ```

#### Applying migrations locally
- Apply migrations frequently to keep the local schema in sync.
- Ensure your branch applies migrations successfully before pushing.
- If migration order changes on `main`, reapply or regenerate your migration.

#### Migration ordering
- Migration order follows merge sequence into `main`.
- Do not rename or delete migrations after they are merged.

#### Prohibited actions
- Do not modify previously committed migration files.
- Do not push model changes without corresponding migrations.
- Do not create or push migrations directly to `main`.

#### CI validation
- CI must run migrations against a test database.
- PRs should only be merged if migrations apply successfully.

## Consequences  

### Benefits
- Stable and predictable migration history  
- Reduced merge conflicts and broken local databases  
- Clear ownership of schema changes  
- Consistent development practices across contributors

### Trade-offs
- Occasional migration regeneration required after merges  
- Developers must stay synced with `main`  
- Requires discipline from all contributors

### Mitigation
- Enforce process in PR reviews  
- CI pipeline validates migrations  
- Documentation and onboarding include migration guidelines  
