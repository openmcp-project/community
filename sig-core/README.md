# SIG Core Charter

## Scope

SIG Core owns the foundational APIs and controllers of OpenControlPlane — including `ControlPlane`, `ServiceProvider`, `ClusterProvider`, and `PlatformService` — as well as platform services considered fundamental to the majority of OpenControlPlane instances. Its primary responsibility is the design, evolution, and health of these core components.

### In Scope

- Core API design and evolution (`ControlPlane`, `ServiceProvider`, `ClusterProvider`, `PlatformService`)
- The main OpenControlPlane operator and its controllers
- Platform services required by most OpenControlPlane platform instances
- Shared controller utilities and libraries used across the project
- Cross-cutting topics with [SIG Extensibility](../sig-extensibility/README.md) such as provider design, discovery, and access management (assigned per-topic)

### Out of Scope

- Extension-specific service providers, cluster providers, and platform services (owned by [SIG Extensibility](../sig-extensibility/README.md))
- Strategic governance decisions reserved for the TSC

## Roles and Responsibilities

### SIG Owner

- **Name(s):** René Schünemann (<rene.schuenemann@sap.com>), Radek Schekalla (<radek.schekalla@sap.com>)
- **Responsibilities:** Organize meetings, maintain charter, communicate with other SIGs, manage roadmap, mentor team members, report to TSC

### SIG Approvers

- **Name(s):** Johannes Aubart (<johannes.aubart@sap.com>), Maximilian Techritz (<maximilian.techritz@sap.com>)
- **Responsibilities:** Review and approve technical changes, provide mentorship, participate in design discussions, maintain code quality

### SIG Contributors

- **Active Contributors:** tbd
- **How to join:** Demonstrate consistent contributions to the SIG's areas

## Subprojects

| Subproject | Owner | Description |
|---|---|---|
| [openmcp-operator](https://github.com/openmcp-project/openmcp-operator) | [@reshnm](https://github.com/reshnm) | Manages the lifecycle of an OpenControlPlane landscape |
| [controller-utils](https://github.com/openmcp-project/controller-utils) | [@Diaphteiros](https://github.com/Diaphteiros) | Reusable Go packages used by multiple Kubernetes controllers |
| [platform-service-gateway](https://github.com/openmcp-project/platform-service-gateway) | [@Diaphteiros](https://github.com/Diaphteiros) | Enables communication across different Kubernetes clusters |
| [platform-service-dns](https://github.com/openmcp-project/platform-service-dns) | [@Diaphteiros](https://github.com/Diaphteiros) | Discovers endpoints of remote services |
| [platform-service-quota](https://github.com/openmcp-project/platform-service-quota) | [@Diaphteiros](https://github.com/Diaphteiros) | Manages resource quota in namespaces |
| [platform-service-resource-replicator](https://github.com/openmcp-project/platform-service-resource-replicator) | [@Diaphteiros](https://github.com/Diaphteiros) | Copies arbitrary resources from a source cluster into different namespaces and/or clusters |

## Communication

- **Meetings:** Bi-weekly on Wednesday at 4PM CET
- **Mailing List:** [opencontrolplane-core@lists.neonephos.org](https://lists.neonephos.org/g/opencontrolplane-core), sign up for updates and receive your invitation to our community call.
- **Documentation:** [OpenControlPlane documentation](https://open-control-plane.io/)

## Decision-Making

### Decision Process

Decisions are made through consensus among approvers. If consensus cannot be reached, the SIG Owner makes the final decision with documented rationale.

### Escalation

Conflicts are first discussed within the SIG. If unresolved after 2 weeks, they are escalated to TSC.

## Roadmap

tbd

## Charter Review

- **Last Updated:** 2026-09-24
- **Next Review:** tbd
- **Review Frequency:** tbd
