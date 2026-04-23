# SIG Extensibility Charter

## Scope

 SIG Extensibility focuses on making it easy to build, share, and adopt extensions like [service providers](https://openmcp-project.github.io/docs/about/concepts/service-provider), [cluster providers](https://openmcp-project.github.io/docs/about/concepts/cluster-provider) and [platform services](https://openmcp-project.github.io/docs/about/concepts/platform-service) in the context of Open Managed Control Planes ([openMCP](https://github.com/openmcp-project)).

Topics like provider design, discovery and access management are cross-cutting with [SIG Core]() and will be discussed and assigned to either SIG on a per-topic basis.

### In Scope

- Increase openMCP service options that end users can choose from.
- Developer joy enabled through templates, frameworks and other contributor-focused tooling.
- Explore technical opportunities to simplify and standardize extensibility in openMCP.

### Out of Scope

- Ownership or modification of core APIs, including `ServiceProvider`, `ClusterProvider`, `PlatformService` and `ManagedControlPlane`. SIG Extensibility may propose improvements to these APIs to [SIG Core]() if identified based on the usage in SIG extensibility.
- Platform services that are considered fundamental and required for the majority of openMCP platform instances (e.g. [platform-service-gateway](https://github.com/openmcp-project/platform-service-gateway)) are owned by [SIG Core]().

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

| Subproject | Owner | Description |
|---|---|---|
| [cluster-provider-kind](https://github.com/openmcp-project/cluster-provider-kind) | [@maximiliantech](https://github.com/maximiliantech) | Use [kind](https://kind.sigs.k8s.io/) to provision clusters in openMCP |
| [cluster-provider-gardener](https://github.com/openmcp-project/cluster-provider-gardener) | [@Diaphteiros](https://github.com/Diaphteiros) | Use [Gardener](https://gardener.cloud/) to provision clusters in openMCP |
| [openmcp-testing](https://github.com/openmcp-project/openmcp-testing) | [@christophrj](https://github.com/christophrj) | Set up e2e test suites for Open Control Plane components |
| [service-provider-crossplane](https://github.com/openmcp-project/service-provider-crossplane) | [@maximiliantech](https://github.com/maximiliantech) | Manages the lifecycle of Crossplane and Crossplane providers |
| [service-provider-external-secrets](https://github.com/openmcp-project/service-provider-external-secrets) | [@christophrj](https://github.com/christophrj) | Manages the lifecycle of External Secrets Operator instances |
| [service-provider-flux](https://github.com/openmcp-project/service-provider-flux) | [@maximiliantech](https://github.com/maximiliantech) | Manages the lifecycle of Flux instances |
| [service-provider-landscaper](https://github.com/openmcp-project/service-provider-landscaper) | [@robertgraeff](https://github.com/robertgraeff) | Manages the lifecycle of Landscaper instances |
| [service-provider-template](https://github.com/openmcp-project/service-provider-template) | [@christophrj](https://github.com/christophrj) | Template for building openMCP service providers |
| [service-provider-velero](https://github.com/openmcp-project/service-provider-velero) | [@christophrj](https://github.com/christophrj) | Manages the lifecycle of Velero instances as-a-Service |
| [service-provider-kro](https://github.com/openmcp-project/service-provider-kro) | [@frewilhelm](https://github.com/frewilhelm) | Manages the lifecycle of kro instances as-a-Service |

## Communication

- **Community Call:** Bi-weekly on Wednesday at 3PM CET
- **Mailing List:** [openMCP-extensibility@lists.neonephos.org](https://lists.neonephos.org/g/openMCP-extensibility), sign up for updates and receive your invitation to our community call.
- **Documentation:** [openMCP-project docs](https://openmcp-project.github.io/docs/)

## Decision-Making

### Decision Process

Decisions are made through consensus among approvers. If consensus cannot be reached, the SIG Owner makes the final decision with documented rationale.

### Escalation

Conflicts are first discussed within the SIG. If unresolved after 2 weeks, they are escalated to TSC.

## Roadmap

SIG Extensibility distinguishes between short-term and long-term activities. The [roadmap](https://github.com/orgs/openmcp-project/projects/15/views/5) provides a three-month outlook on planned work.

Short-term activities have a commitment to be actively worked on within the next three months and are put in the backlog and tracked in the [backlog view](https://github.com/orgs/openmcp-project/projects/15/views/3).

Long-term activities are captured in the [feature requests view](https://github.com/orgs/openmcp-project/projects/15/views/15). Feature requests serve as the primary mechanism for discussing and refining future work. If a feature requires additional documentation, create a PR in the community repo with a ADR, RFC or enhancement proposal markdown file under [sig-extensibility](../sig-extensibility/) to discuss the request. Issues related to a feature request are put into the [SIG Extensibility backlog](https://github.com/orgs/openmcp-project/projects/15/views/3) once a feature has been refined and the commitment to implement the feature has been made.

## Charter Review

- **Last Updated:** 2026-02-23
- **Next Review:** tbd
- **Review Frequency:** tbd
