# SIG Extensibility Charter

## Scope

 SIG Extensibility focuses on making it easy to build, share, and adopt extensions like [service providers](https://openmcp-project.github.io/docs/about/concepts/service-provider), [cluster providers](https://openmcp-project.github.io/docs/about/concepts/cluster-provider) and [platform services](https://openmcp-project.github.io/docs/about/concepts/platform-service) in the context of the [OpenControlPlane project](https://open-control-plane.io/).

Topics like provider design, discovery and access management are cross-cutting with [SIG Core]() and will be discussed and assigned to either SIG on a per-topic basis.

### In Scope

- Increase OpenControlPlane service options that end users can choose from.
- Developer joy enabled through templates, frameworks and other contributor-focused tooling.
- Explore technical opportunities to simplify and standardize extensibility in OpenControlPlane.

### Out of Scope

- Ownership or modification of core APIs, including `ServiceProvider`, `ClusterProvider`, `PlatformService` and `ManagedControlPlane`. SIG Extensibility may propose improvements to these APIs to [SIG Core]() if identified based on the usage in SIG extensibility.
- Platform services that are considered fundamental and required for the majority of OpenControlPlane platform instances (e.g. [platform-service-gateway](https://github.com/openmcp-project/platform-service-gateway)) are owned by [SIG Core]().

## Roles and Responsibilities

### SIG Owner

- **Name(s):** Maximilian Techritz (<maximilian.techritz@sap.com>), Christopher Junk (<christopher.junk@sap.com>)
- **Responsibilities:** Organize meetings, maintain charter, communicate with other SIGs, manage roadmap, mentor team members, report to TSC

### SIG Approvers

- **Name(s):** Maximilian Techritz (<maximilian.techritz@sap.com>), Christopher Junk (<christopher.junk@sap.com>)
- **Responsibilities:** Review and approve technical changes, provide mentorship, participate in design discussions, maintain code quality

### SIG Contributors

- **Active Contributors:** tbd
- **How to join:** Demonstrate consistent contributions to the SIG's areas

## Subprojects

| Subproject                                                                                                | Owner                                                                                     | Description                                                                                             |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [cluster-provider-gardener](https://github.com/openmcp-project/cluster-provider-gardener)                 | [@Diaphteiros](https://github.com/Diaphteiros)                                            | Use [Gardener](https://gardener.cloud/) to provision clusters in OpenControlPlane                                |
| [cluster-provider-kind](https://github.com/openmcp-project/cluster-provider-kind)                         | [@maximiliantech](https://github.com/maximiliantech)                                      | Use [kind](https://kind.sigs.k8s.io/) to provision clusters in OpenControlPlane                                  |
| [opencontrolplane-gen](https://github.com/openmcp-project/opencontrolplane-gen)                           | [@christophrj](https://github.com/christophrj)                                            | A code transformation tool to use with go generate |
| [opencontrolplane-runtime](https://github.com/openmcp-project/opencontrolplane-runtime)                   | [@christophrj](https://github.com/christophrj)                                            | A set of libraries for writing OpenControlPlane ServiceProviders, PlatformServices and ClusterProviders |
| [openmcp-testing](https://github.com/openmcp-project/openmcp-testing)                                     | [@christophrj](https://github.com/christophrj)                                            | Set up e2e test suites for OpenControlPlane components                                                  |
| [platform-service-template](https://github.com/openmcp-project/platform-service-template)                 | [@christophrj](https://github.com/christophrj)                                            | Template for building OpenControlPlane Platform Services |
| [service-provider-crossplane](https://github.com/openmcp-project/service-provider-crossplane)             | [@maximiliantech](https://github.com/maximiliantech)                                      | Manages the lifecycle of Crossplane and Crossplane providers                                            |
| [service-provider-external-secrets](https://github.com/openmcp-project/service-provider-external-secrets) | [@christophrj](https://github.com/christophrj)                                            | Manages the lifecycle of External Secrets Operator instances                                            |
| [service-provider-flux](https://github.com/openmcp-project/service-provider-flux)                         | [@maximiliantech](https://github.com/maximiliantech)                                      | Manages the lifecycle of Flux instances                                                                 |
| [service-provider-kro](https://github.com/openmcp-project/service-provider-kro)                           | [@frewilhelm](https://github.com/frewilhelm)                                              | Manages the lifecycle of kro instances as-a-Service                                                     |
| [service-provider-kyverno](https://github.com/openmcp-project/service-provider-kyverno)                   | [@SatabdiG](https://github.com/SatabdiG) [@sdischer-sap](https://github.com/sdischer-sap) | Manages the lifecycle of Kyverno instances as-a-Service                                                 |
| [service-provider-landscaper](https://github.com/openmcp-project/service-provider-landscaper)             | [@robertgraeff](https://github.com/robertgraeff)                                          | Manages the lifecycle of Landscaper instances                                                           |
| [service-provider-template](https://github.com/openmcp-project/service-provider-template)                 | [@christophrj](https://github.com/christophrj)                                            | Template for building OpenControlPlane service providers                                                         |
| [service-provider-velero](https://github.com/openmcp-project/service-provider-velero)                     | [@christophrj](https://github.com/christophrj)                                            | Manages the lifecycle of Velero instances as-a-Service                                                  |

## Communication

- **Community Call:** Bi-weekly on Wednesday at 3PM CET
- **Mailing List:** [opencontrolplane-extensibility@lists.neonephos.org](https://lists.neonephos.org/g/opencontrolplane-extensibility), sign up for updates and receive your invitation to our community call.
- **Documentation:** [OpenControlPlane documentation](https://open-control-plane.io/)

## Decision-Making

### Decision Process

Decisions are made through consensus among approvers. If consensus cannot be reached, the SIG Owner makes the final decision with documented rationale.

### Escalation

Conflicts are first discussed within the SIG. If unresolved after 2 weeks, they are escalated to TSC.

## Roadmap

The [roadmap](https://github.com/orgs/openmcp-project/projects/15/views/5) provides a three-month outlook on planned work.

## Charter Review

- **Last Updated:** 2026-06-18
- **Next Review:** tbd
- **Review Frequency:** tbd
