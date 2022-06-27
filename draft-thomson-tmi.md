---
title: "Principles for the Involvement of Intermediaries in Internet Protocols"
abbrev: "Too Much Intermediation"
docname: draft-thomson-tmi-latest
category: info
ipr: trust200902

stand_alone: yes
pi: [toc, sortrefs, symrefs, docmapping]

author:
 -
    name: Martin Thomson
    org: Mozilla
    email: mt@lowentropy.net

informative:

  PATTERNS:
    title: "Design Patterns: Elements of Reusable Object-Oriented Software"
    date: 1994
    author:
      - name: Erich Gamma
      - name: Richard Helm
      - name: Ralph Johnson
      - name: John Vlissides


--- abstract

This document proposes a set of principles for designing protocols with rules
for intermediaries.  The goal of these principles is to limit the ways in which
intermediaries can produce undesirable effects and to protect the useful
functions that intermediaries legitimately provide.

--- middle

# Introduction

The Internet owes much of its success to its application of the end-to-end
principle {{?E2E=DOI.10.1145/357401.357402}}.  The realization that efficiency
is best served by moving higher-level functions to endpoints is a key insight
in system design, but also a key element of the success of the Internet.

This does not mean that the Internet avoids a relying on functions provided by
entities in the network.  While the principle establishes that some functions
are best provided by endsystems, this does not exclude all intermediary
functions.  Some level of function in the network is necessary, or else there
would be no network.  The ways in which intermediaries can assist protocol
endpoints are numerous and constantly evolving.

This document explores some of the ways in which intermediaries make both
essential and valuable contributions to the function of the system.  Problems
arise when the interests of intermediaries are poorly aligned with those of
endpoints.  This can result in systemic costs and tension.  Addressing those
issues can be difficult.

This document proposes the following design principles for the protocols that
might involve the participation of intermediaries:

* Avoid intermediation ({{prefer-services}})
* Limit the entities that can intermediate ({{limit-participants}})
* Limit what intermediaries can do ({{limit-capabilities}})

These principles aim to provide clarity about the roles and responsibilities of
protocol participants.  These principles produce more robust protocols with
better privacy and security properties.  These also limit the secondary costs
associated with intermediation.


# What is Meant by Intermediary

An intermediary is an element that participates in a protocol exchange.  An
intermediary receives protocol units, such as packets or messages, and forwards
the protocol units to other protocol participants.  An intermediary might
make changes to protocol units or leave the content of the unit unchanged.

An intermediary often does not directly benefit from the protocol exchange, but
instead acts to facilitate the exchange.  An intermediary often participates at
the request of another participant in the protocol, which might be an endpoint
or an intermediary.

Intermediaries exist at all layers of the stack.  A router is an intermediary
that acts at the network layer to forward packets.  A TURN relay {{?RFC8155}}
provides similar forwarding capability for UDP in the presence of a network
address translator (NAT) - a different type of intermediary that provides the
ability to share a limited supply of addresses.  At higher layers of the stack,
group messaging servers intermediate the exchange of messages within groups of
people; a conference focus aids the sending of media group real-time
communications; and a social network intermediates communication and
information sharing through the exchange of messages and formation of groups.

A person uses a networked computer as an intermediary for their communications
with other people and computers.  This intermediation is essential, for users
are unable to directly interact with a network.  Much of the guidance in this
document does not apply to the relationship between users and user agents; see
{{?RFC8890}}, Section {{Section 4.2 of ?RFC8890}}{: sectionFormat="bare"} in
particular, for an examination of this topic.

An intermediary at one layer of the stack is often an endpoint for communication
at a lower layer.  A Diameter peer {{?DIAMETER=RFC6733}} acts as an intermediary
when it forwards requests to other peers.  However, a Diameter peer establishes
connections to neighboring peers using TLS/TCP or DTLS/SCTP and acts as a
endpoint for all of those protocols.

It is possible to facilitate communication without being an intermediary.  The
DNS provides information that is critical to locating and communicating with
other Internet hosts, but it does so without intermediating those
communications.  Thus, this definition of intermediary does not necessarily
include a service like the DNS.  Of course, the use of the DNS could involve
engaging with intermediaries such as recursive resolvers.


# Intermediation Is Essential

Intermediaries are essential to scalable communications.  The service an
intermediary provides usually involves access to resources that would not
otherwise be available.  For instance, the Internet does not function without
routers that enable packets to reach other networks.

There is some level of intermediation that is essential for the proper
functioning of the Internet.

Scalable solutions to the introduction problem often depend on services that
provide access to information and capabilities.  As it is with the network layer
of the Internet, the use of an intermediary can be absolutely essential.  For
example, a social networking application acts as an intermediary that provides a
communications medium, content discovery and publication, and related services.
Video conferencing applications often depend on an intermediary that mixes audio
and selectively forwards video so that bandwidth requirements don't increase
beyond what is available for participants as conferences grow in size.


# Intermediation Is Useful

That intermediaries provide access to valuable resources does not imply that
all intermediaries have exclusive control over access to resources.  A router
might provide access to other networks, but similar access might be obtained
via a different route.  The same web content might be provided by multiple CDNs.
Multiple DNS resolvers can provide answers to the same queries.  The ability to
access the same capabilities from multiple entities contributes greatly to the
robustness of a system.

Intermediaries often provide capabilities that benefit from economies of scale
by providing a service that aggregates demand from multiple individuals.  For
instance, individuals are unlikely to be in a position to negotiate connections
to multiple networks, but an ISP can.  Similarly, an individual might find it
difficult to acquire the capacity necessary to withstand a DDoS attack, but the
scale at which a CDN operates means that this capacity is likely available to
it.  Or the value of a social network is in part due to the existing
participation of other people.

Aggregation also provides other potential benefits.  For instance, caching of
shared information can allow for performance advantages.  From an efficiency
perspective, the use of shared resources might allow load to be more evenly
distributed over time.  For privacy, individual activity might be mixed with the
activity of many others, thereby making it difficult to isolate that activity.

The ability of an intermediary to operate at scale can therefore provide a
number of different benefits to performance, scalability, privacy, and other
areas.


# Intermediation Enables Scaling Of Control {#scale}

An action by an intermediary can affect all who communicate using that
intermediary.  For an intermediary that operates at scale, this means it can be
seen as an effective control point.

In addition to facilitating communications, some intermediary deployments aim to
effect a policy. This relies on the ability of a well-placed intermediary to
affect multiple protocol interactions and participants.

The ability of an intermediary to affect a large number of network users can be
an advantage or vulnerability, depending on perspective.  For instance, network
intermediaries have been used to distribute warnings of impending natural
disasters like fire, flood, or earthquake, which save lives and property.  In
contrast, control over large-scale communications can enable censorship
{{?RFC7754}}, misinformation {{?PARADOX=DOI.10.1080/21670811.2019.1623701}}, or
pervasive monitoring {{?RFC7258}}.

Intermediaries that can affect many people can therefore be powerful agents for
control.  While the morality of actions taken can be subjective, network users
have to consider the potential for the power they vest in intermediaries to be
abused or subverted.


# Incentive Misalignment at Scale {#incentives}

A dependency on an intermediary represents a risk to those that take the
dependency.  The incentives and motives of intermediaries can be important to
consider when choosing to use an intermediary.

For instance, the information necessary for an intermediary to performs its
function can often be used (or abused) for other purposes.  Even the simple
function of forwarding necessarily involves information about who was
communicating, when, and the size of messages.  This can reveal more than is
obvious {{?CLINIC=DOI.10.1007/978-3-319-08506-7_8}}.

As uses of networks become more diverse, the extent that incentives for
intermediaries and network users align reduce.  In particular, acceptance of
the costs and risks associated with intermediation by a majority of network
users does not mean that all users have the same expectations and requirements.
This can be a significant problem if it becomes difficult to avoid or refuse
participation by a particular intermediary.

A dependency on an intermediary, particularly a technically or operationally
challenging dependency, can reduce the number of viable choices of intermediary
operators.  Reduced choice can lead to dependence on specific intermediaries,
which reduces resilience and exposes endpoints to greater potential for abuse.


# Forced and Unwanted Intermediation

The ability to act as intermediary can offer more options than a service that is
called upon to provide information.  Sometimes those advantages are enough to
justify the use of intermediation over alternative designs.  However, the use of
an intermediary also introduces costs.

The use of transparent or interception proxies in HTTP
{{?HTTP=I-D.ietf-httpbis-semantics}} is an example of a practice that has
fallen out of common usage due to increased use of HTTPS.  Use of transparent
proxies was once widespread with a wide variety of reasons for their
deployment.  However, transparent proxies were involved in many abuses, such as
unwanted transcoding of content and insertion of identifiers to the detriment
of individual privacy.

Introducing intermediaries is often done with the intent of avoiding disruption
to protocols that operate a higher layer of the stack.  However, network
layering abstractions often leak, meaning that the effects of the intermediation
can be observed.  Where those effects cause problems, it can be difficult to
detect and fix those problems.

The insertion of an intermediary in a protocol imposes other costs on other
protocol participants; see {{?EROSION=I-D.hildebrand-middlebox-erosion}} or
{{?MIDDLEBOX=RFC3234}}.  In particular, poor implementations of intermediaries
can adversely affect protocol operation.

As an intermediary is another participant in a protocol, they can make
interactions less robust.  Intermediaries can also be responsible for
ossification, or the inability to deploy new protocol mechanisms; see {{Section
2.3 of ?USE-IT=RFC9170}}.  For example, measurement of TCP showed that the
protocol has poor prospects for extensibility due to widespread use - and poor
implementation - of intermediaries {{?TCP-EXTEND=DOI.10.1145/2068816.2068834}}.


# Contention over Intermediation

The IETF has a long history of dealing with different forms of intermediation
poorly.

A debate about the intent and purpose of IPv6 extension headers
{{?IPv6=RFC8200}} occurred prior to the publication of RFC 8986
{{?SRv6=RFC8986}} and it's PSP (Penultimate Segment Pop) mode.  Here, the use of
extension headers by entities other than the communication endpoints -- that is,
intermediaries -- was contested.  As the purpose of this feature is to
communicate routing information between intermediaries, this could be seen as a
form of tunneling between the communicating routers that uses the ability of
IPv6 intermediaries (or routers) to add or remove extension headers.

Like HTTP, SIP {{?RFC3261}} defines a role for a proxy, which is a form of
intermediary with limited ability to interact with the session that it
facilitates.  In practice, many deployments instead choose to deploy some form
of Back-to-Back UA (B2BUA; {{?RFC7092}}) for reasons that effectively reduce to
greater ability to implement control functions.

There are several ongoing debates in the IETF that are rooted in disagreement
about the rule of intermediaries.  The interests of network-based devices --
which sometimes act as TLS intermediaries -- is fiercely debated in the context
of TLS 1.3 {{?TLS=RFC8446}}, where the design renders certain practices
obsolete.

It could be that the circumstances in each of these debates is different enough
that there is no singular outcome.  The complications resulting from large-scale
deployments of great diversity might render a single clear outcome impossible
for an established protocol.


# Proposed Principles {#principles}

Many problems caused by intermediation are the result of intermediaries that
are introduced without the involvement of protocol endpoints.  Limiting the
extent to which protocol designs depend on intermediaries makes the resulting
system more robust.

These principles are set out in three stages:

1. Prefer designs without intermediaries ({{prefer-services}});
2. Failing that, control which entities can intermediate the protocol
   ({{limit-participants}}); and
3. Limit actions and information that are available to intermediaries
   ({{limit-capabilities}}).

The use of technical mechanisms to ensure that these principles are enforced is
necessary.  It is expected that protocols will need to use cryptography for
this.

New protocol designs therefore need to identify what intermediation is possible
and what is desired.  Technical mechanisms to guarantee conformance, where
possible, are highly recommended.

Modifying existing protocols to follow these principles could be difficult, but
worthwhile.


## Prefer Services to Intermediaries {#prefer-services}

Protocols should prefer designs that do not involve additional participants,
such as intermediaries.

Designing protocols to use services rather than intermediaries ensures that
responsibilities of protocol participants are clearly defined.  Where functions
can provided by means other than intermediation, the design should prefer that
alternative.

If there is a need for information, defining a means for querying a service for
that information is preferable to adding an intermediary.  Similarly, direct
invocation of service to perform an action is better than involving that
service as a participant in the protocol.

Involving an entity as an intermediary can greatly increase the degree to which
that entity becomes a dependency.  For example, it might be necessary to
negotiate the use of new capabilities with all protocol participants, including
the intermediary, even when the functions for which the intermediary was added
are not affected.  It is also more difficult to limit the extent to which a
protocol participant can be involved than a service that is invoked for a
specific task.

Using discrete services is not always the most performant architecture as
additional network interactions can add to overheads.  The cost of these
overheads need to be weighed against the recurrent costs from involving
intermediaries.

The contribution of an intermediary to performance and efficiency can involve
trade-offs, such as those discussed in Section 2.3 of {{?E2E}}.  One
consideration is the potential need for critical functions to be replicated in
both intermediaries and endpoints, reducing efficiency.  Another is the
possibility that an intermediary optimized for one application could degrade
performance in other applications.

Preferring services is analogous to the software design principle that
recommends a preference for composition over inheritance {{PATTERNS}}.


## Deliberately Select Protocol Participants {#limit-participants}

Protocol participants should know what other participants they might be
interacting with, including intermediaries.

Protocols that permit the involvement of an intermediary need to do so
intentionally and provide measures that prevent the addition of unwanted
intermediaries.  Ideally, all protocol participants are identified and known to
other protocol participants.

The addition of an unwanted protocol participant is an attack on the protocol.

This is an extension of the conclusion of {{?PATH-SIGNALS=RFC8558}}, which:

{:quote}
> recommends that implicit signals should be avoided and that an implicit signal
> should be replaced with an explicit signal only when the signal's originator
> intends that it be used by the network elements on the path.

Applying this principle likely requires the use of authentication and
encryption.


## Limit Capabilities of Intermediaries {#limit-capabilities}

Protocol participants should be able to limit the capabilities conferred to
other protocol participants.

Where the potential for intermediation already exists, or intermediaries
provide essential functions, protocol designs should limit the capabilities and
information that protocol participants are required to grant others.

Limiting the information that participants are required to provide to other
participants has benefits for privacy or to limit the potential for misuse of
information; see {{limit-info}}.  Where confidentiality is impossible or
impractical, integrity protection can be used to ensure that data origin
authentication is preserved; see {{limit-changes}}.


### Limit Information Exposure {#limit-info}

Protocol participants should only have access to the information they need to
perform their designated function.

Protocol designs based on a principle of providing the minimum information
necessary have several benefits.  In addition to requiring smaller messages, or
fewer exchanges, reducing information provides greater control over exposure of
information.  This has privacy benefits.

Where an intermediary needs to carry information that it has no need to access,
protocols should use encryption to ensure that the intermediary cannot access
that information.

Providing information for intermediaries using signals that are separate from
other protocol signaling is preferable {{?PATH-SIGNALS}}.  In addition,
integrity protection should be applied to these signals to prevent modification.


### Limit Permitted Interactions {#limit-changes}

An action should only be taken based on signals from protocol participants that
are authorized to request that action.

Where an intermediary needs to communicate with other protocol participants,
ensure that these signals are attributed to an intermediary.  Authentication is
the best means of ensuring signals generated by protocol participants are
correctly attributed.  Authentication informs decisions protocol participants
make about actions they take.

In some cases, particularly protocols that are primarily two-party protocols,
it might be sufficient to allow the signal to be attributed to any
intermediary.  This is the case in QUIC {{?QUIC=I-D.ietf-quic-transport}} for
ECN {{?ECN=RFC3168}} and ICMP {{?ICMP=RFC0792}}, both of which are assumed to
be provided by elements on the network path.  Limited mechanisms exist to
authenticate these as signals that originate from path elements, informing
actions taken by endpoints.  Consequently, the actions taken in response to
these signals is limited.


### Costs of Technical Constraints

Moving from a protocol in which there are two participants (such as
{{?TLS=RFC8446}}) to more than two participants can be more complex and
expensive to implement and deploy.

More generally, the application of technical measures to control how
intermediaries participate in a protocol incur costs that manifest in several
ways.  Protocols are more difficult to design; implementations are larger and
more complex; and deployments might suffer from added operational costs, higher
computation loads, and more bandwidth consumption.  These costs are reflective
of the true cost of involving additional entities in protocols.  In protocols
without technical measures to limit participation, these costs have
historically been borne by other protocol participants.

In general however, most protocols are able to reuse existing mechanisms for
cryptographic protection, such as TLS {{?TLS}}.  Adopting something like TLS
provides security properties that are well understood and analyzed.  Using a
standardized solution enables use of well-tested implementations that include
optimizations and other mitigations for these costs.


# Applying Non-Technical Constraints

Not all intermediary functions can be tightly constrained.  For instance, as
described in {{incentives}}, some functions involve granting intermediaries
access to information that can be used for more than its intended purpose.
Applying strong technical constraints on how that information is used might be
infeasible or impossible.

Systems that audit the involvement in protocols can use authentication to
improve accountability.  Authentication can enable the use of legal,
social, or other types of control that might cover any shortfall in technical
measures.


# The Effect on Existing Practices

The application of these principles can have an effect on existing operational
practices, particularly where they rely on protocols not limiting intermediary
access.  Several documents have explored aspects of this in detail:

* {{?RFC8404}} describes effects of encryption on practices performed by
  intermediaries;

* {{?RFC8517}} describes a broader set of practices;

* {{?RFC9065}} explores the effect on transport-layer intermediaries in more
  detail; and

* {{?NS-IMPACT=I-D.ietf-opsec-ns-impact}} examines the effect of TLS on
  operational network security practices.

In all these documents, the defining characteristic is the move from a system
that lacked controls on participation to one in which technical controls are
employed.  In each case, the protocols in question provided little or no
technical controls that prevented the addition of intermediaries.  This allowed
for the insertion of intermediaries into sessions without permission or
knowledge of other protocol participants.  Adding controls like encryption
and authentication disrupts these practices.

Overall, the advantages derived from having greater control and
knowledge of other protocol participants outweighs these costs.

In these settings, finding ways for intermediaries to contribute is an ongoing
process.  When looking at how intermediaries contributed to protocols operation
prior to the introduction of technical controls there are three potential
classes of outcome of these discussion:

* Practices might be deemed valuable.  Facilities might be added to protocols to
  allow or encourage those practices.

* The use case supported by the practice might be deemed valuable, however it
  might than an alternative approach has more desirable properties.

* Practices might be deemed harmful and no replacement mechanism will be
  sought.

Many factors could influence the outcome of this analysis.  For instance,
deployment of alternative methods or limited roles for intermediaries could be
relatively simple for new protocol deployments; whereas it might be challenging
to retrofit controls on existing protocol deployments.


# Security Considerations

Controlling the level of participation and access intermediaries have is a
security question.  The principles in {{principles}} are fundamentally an
application of a security principle: namely the principle of least privilege
{{?LEAST-PRIVILEGE=DOI.10.1145/361011.361067}}.

Lack of proper controls on intermediaries in protocols has been the source of
significant security problems.  One key example is where protocols allow an
intermediary to consume, modify, or generate protocol units in ways that are
contrary to the interests of other protocol participants.


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments

This document is merely an attempt to codify existing practice.  Practice that
is inspired, at least in part, by prior work, including {{?RFC3552}} and
{{?RFC3724}} which both advocate for clearer articulation of trust boundaries.

{{{Jari Arkko}}}, {{{Eric Rescorla}}}, and {{{David Schinazi}}} are acknowledged
for their contributions of thought, review, and text.
