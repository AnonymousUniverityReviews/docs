# 2. Backend architecture

Date: 2025-10-26

## Status

Accepted

## Context

The team needed to select an appropriate architectural style for the backend system. The choice was between a **monolithic architecture** and a **microservices architecture**.  
Several factors influenced this decision, including the team’s current level of experience, project complexity, expected user load, and the need for rapid initial development.

This project is still in the early stages and is being developed by a small team with limited experience in distributed systems. The primary goal is to build a stable, maintainable, and easy-to-deploy backend that supports the required functionality without introducing unnecessary operational complexity.

## Decision

We decided to implement the backend as a **monolithic architecture** rather than adopting a microservices approach.

A monolithic architecture consolidates all core components — such as authentication, scheduling, and API logic — within a single deployable unit. Internal modules will remain clearly separated by namespaces and layers to maintain good internal structure and prepare for potential modularization in the future.

### Reasons for choosing Monolith

1. **Ease of development:** The team can work within one codebase without needing to manage complex service boundaries, communication protocols, or distributed tracing.
2. **Simpler deployment:** A single deployment process is easier to automate and monitor compared to managing multiple independent services.
3. **Team experience:** The developers are still gaining experience with backend architecture and do not yet have the necessary knowledge to design and maintain a microservices system.
4. **Faster iteration:** A monolith allows for quicker feature development and testing cycles, which is valuable at this stage of the project.
5. **Lower infrastructure complexity:** No need to manage service discovery, message queues, or container orchestration (e.g., Kubernetes) at this time.

## Consequences

### Positive

- **Lower operational overhead:** Simpler deployment pipelines and monitoring.
- **Easier debugging and testing:** All components run within a single process, simplifying tracing and error reproduction.
- **Faster initial delivery:** Fewer infrastructure dependencies mean the team can focus on features.

### Negative / Risks

- **Scalability limits:** Scaling the entire application as one unit may become inefficient if the user base grows significantly.
- **Slower builds over time:** As the codebase expands, build and deploy times may increase.
- **Potential technical debt:** Without careful modular design, the code could become tightly coupled and harder to split later.

### Mitigation Strategies

- Keep a **modular internal structure** (by layers and namespaces) to make future extraction into services easier.  
- Establish **clear API boundaries** between internal modules.  
- Document architectural assumptions and review this decision periodically — especially if the team or system size grows.

