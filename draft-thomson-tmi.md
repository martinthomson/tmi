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
    ins: M. Thomson
    name: Martin Thomson
    org: Mozilla
    email: mt@lowentropy.net

informative:

  PATTERNS:
    title: "Design Patterns: Elements of Reusable Object-Oriented Software"
    date: 1994
    author:
      - ins: E. Gamma
      - ins: R. Helm
      - ins: R. Johnson
      - ins: J. Vlissides


--- abstract

This document proposes a set of principles for designing protocols with rules
for intermediaries.  The goal of these principles is to limit the ways in which
intermediaries can produce undesirable effects and to protect the useful
functions that intermediaries legitimately provide.  These principles aim to
establish clarity regarding the role of intermediaries in protocols and produce
protocols with controls on intermediary actions that increase confidence in
intermediary participation.

--- middle

# Introduction

The Internet owes much of its success to its application of the end-to-end
principle {{?E2E=DOI.10.1145/357401.357402}}.  The realization that efficiency
is best served by moving higher-level functions to endpoints is a key insight
in system design, but also a key element of the success of the Internet.

This does not mean that the Internet inevitably avoids a reliance on functions
provided by entities in the network.  Indeed, while the principle establishes
that some functions are best provided by endsystems, this is not to the complete
exclusion of intermediary functions.  Some level of function in the network is
absolutely necessary, or else there would be no network.  The ways in which
intermediaries can assist protocol endpoints are numerous and constantly
evolving.

This document explores some of the ways in which intermediaries make both
essential and valuable contributions to the function of the system.  Problems
arise when the interests of intermediaries are poorly aligned with those of
endpoints.  This can result in systemic costs and tension.  Resolving issues
arising from these conflicts can be challenging.

This document proposes the following design principles for the protocols that
might involve the participation of intermediaries:

* Avoid intermediation ({{prefer-services}})
* Limit the entities that can intermediate ({{limit-participants}})
* Limit what intermediaries can do ({{limit-capabilities}})
* Limit what intermediaries can see ({{limit-info}})
* Limit what intermediaries can change ({{limit-changes}})

These principles produce more robust protocols with better privacy and security
properties.  These also limit the secondary costs associated with
intermediation.  Adherence with these principles will ensure clarity about the
role of important intermediation functions.


# What is Meant by Intermediary

A protocol intermediary is an element that participates in communications.  An
intermediary is not the primary initiator or recipient of communications, but
instead acts to facilitate communications.

An intermediary need not be explicitly present at the request of a participant.

Intermediaries exist at all layers of the stack.  A router is an intermediary
that acts at the network layer to forward packets.  A TURN relay {{?RFC8155}}
provides similar forwarding capability for UDP in the presence of a network
address translator (NAT) - a different type of intermediary that provides the
ability to share a limited supply of addresses.  At higher layers of the stack,
group messaging servers intermediate the exchange of messages within groups of
people; and a social network intermediates in communication and information
sharing through the exchange of messages and formation of groups.

It is possible to facilitate communication without being an intermediary.  The
DNS provides information that is critical to locating and communicating with
other Internet hosts, but it does so without intermediating those
communications.  Thus, this definition of intermediary does not include services
like the DNS.  That said, though the DNS as a service does not result in
intermediation of other activities, there are roles for intermediaries within
the DNS that fit this definition, such as recursive resolvers.


# Intermediation Is Essential

Intermediaries are essential to scalable communications.  The service an
intermediary provides usually involves access to resources that would not
otherwise be available.  For instance, the Internet does not function without
routers that enable packets to reach other networks.

Thus, there is some level of intermediation that is essential for the proper
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

Intermediaries often contribute value that is difficult to acquire in other
ways.  Use of an intermediary might allow access to resources that are otherwise
unavailable, or that are uniquely a property of the function of the
intermediary.

This does not imply that all intermediaries have exclusive control over access
to resources.  A router might provide access to other networks, but similar
access might be obtained via a different route.  The same web content might be
provided by multiple CDNs.  Multiple DNS servers can provide answers to the same
questions.  The ability to access the same capabilities from multiple entities
contributes greatly to the robustness of a system.

Intermediaries often provide capabilities that benefit from economies of scale
by providing a service that aggregates demand from multiple individuals.  For
instance, individuals are unlikely to be in a position to negotiate connectivity
to multiple networks, but an ISP can.  Similarly, an individual might find it
difficult to acquire the capacity necessary to withstand a DDoS attack, but the
scale at which a CDN operates means that this capacity is likely available to
it.  Or the value of a social network is in part due to the existing
participation of other people.

Aggregation also provides other potential benefits.  For instance, caching of
shared information can allow for performance advantages that mitigate against
delays resulting from distance between communicating endpoints.  From an
efficiency perspective, the use of shared resources might allow load to be more
evenly distributed over time.  For privacy, individual activity might be
intermixed with the activity of many others, thereby making it difficult to
distinguish that activity and identify its origin.

The ability of an intermediary to operate at scale can therefore provide a
range of advantages in performance, scalability, privacy, and other areas that
accrue to the system as a whole.


# Intermediation Enables Scaling Of Control

The scale at which intermediaries operate means that they are often seen as
effective control points in the systems that depend on them.  An action by an
intermediary can affect all who communicate using that intermediary.

The ability of an intermediary to affect a large number of network users can be
an advantage or vulnerability, depending on perspective.  For instance, network
intermediaries have been used to distribute warnings of impending natural
disasters like fire, flood, or earthquake, which save lives and property.  In
contrast, control over large-scale communications can enable censorship,
misinformation, or pervasive monitoring {{?RFC7258}}.

The scale at which an intermediary operates therefore enables amplification of
any power available to that intermediary.  Though it is clear that the morality
of actions taken can be subjective, network users have to consider the potential
for the power they vest in intermediaries to be abused or subverted.


# Incentive Misalignment at Scale {#incentives}

Many intermediary functions depend on some limited form of trust in the
intermediary.  In considering the potential for an intermediary to abuse powers,
the goals of intermediaries are particularly relevant to determining whether
there is any motive toward abuse of trust.

For instance, the information necessary for an intermediary to performs its
function can often be used (or abused) for other purposes.  Even the simple
function of forwarding necessarily involves information about who was
communicating, when, and the size of messages.

As uses of networks become more diverse, the ability of an intermediary to
effectively address the needs of network users diminishes.  In particular,
acceptance of the costs and risks associated with intermediation by a majority
of network users does not mean that all users have the same expectations and
requirements.  This can be a significant problem if it becomes difficult to
avoid or refuse participation by a particular intermediary; see (TODO
CHOKEPOINTS=I-D.iab-chokepoints).


# Forced and Unwanted Intermediation

The ability to act as intermediary can offer more options than a service that is
called upon to provide information.  Sometimes those advantages are significant
enough to justify the use of intermediation over alternative designs.  However,
the use of an intermediary also introduces costs; see {{limit-participants}}.

The use of transparent or interception proxies in HTTP {{?HTTP=RFC7230}} is an
example of a practice that has fallen out of common usage due to increased use
of HTTPS.  Use of transparent proxies was once widespread with a wide variety of
reasons for their deployment.   However, transparent proxies were involved in
many abuses, such as unwanted transcoding of content and insertion of
identifiers to the detriment of individual privacy.

As an intermediary is another participant in a protocol, they can make
interactions less robust.  Unwanted intermediaries are also responsible for
ossification - the inability to deploy new protocol mechanisms - in popular
protocols like TCP {{?TCP-EXTEND=DOI.10.1145/2068816.2068834}}.

The insertion of an intermediary in a protocol can impose a number of costs on
other protocol participants; see {{?EROSION=I-D.hildebrand-middlebox-erosion}}
or {{?MIDDLEBOX=RFC3234}}.  In particular, intermediaries can limit how other
participants are able to use new protocol features; see Section 2.3 of
{{?USE-IT=I-D.iab-use-it-or-lose-it}}.


# Contention over Intermediation

The IETF has a long history of dealing with different forms of intermediation
poorly.

Early use of NAT was loudly decried by some in the IETF community.  Indeed, the
use of NAT was regarded as an unwanted intrusion by intermediaries.  The
eventual recognition - though not an endorsement - of the existence of NAT
({{?MIDDLEBOX=RFC3234}}, {{?NAT-ARCH=RFC2993}}) allowed the community to engage
in the design protocols that properly handled NAT devices ({{?UNSAF=RFC3424}},
{{?STUN=I-D.ietf-tram-stunbis}}) and to make recommendations for best practices
{{?BEHAVE=RFC4787}}.

Like HTTP, SIP {{?RFC3261}} defines a role for a proxy, which is a form of
intermediary with limited ability to interact with the session that it
facilitates.  In practice, many deployments instead choose to deploy some form
of Back-to-Back UA (B2BUA; {{?RFC7092}}) for reasons that effectively reduce to
greater ability to implement control functions.

There are several ongoing debates in the IETF that are rooted in disagreement
about the rule of intermediaries.  The interests of network-based
devices - which are sometimes intermediaries - is fiercely debated in the
context of TLS 1.3 {{?TLS=RFC8446}}, where the design renders certain practices
obsolete.  Proposed uses of IPv6 header extensions in
{{?SRv6NP=I-D.ietf-spring-srv6-network-programming}} called into question the
extent to which header extensions are the exclusive domain of endpoints as
opposed to being available to intermediaries.

It could be that the circumstances in each of these debates is different enough
that there is no singular outcome.  The complications resulting from large-scale
deployments of great diversity might render a single clear outcome impossible
for an established protocol.  However, these cases demonstrate the potential
value of having a set of guiding principles.


# Proposed Principles

The principles included in this section are intended for protocol designers.
Adherence to these principles is desirable, especially for new protocols.  For
existing protocols, it is likely that deployment of changes to more closely
follow this principles is difficult, but that does not mean that the cost is not
worthwhile.

Even where the particulars of a case suggest a contradictory outcome,
consideration of these principles can inform the decision-making process.

Intermediaries are protocol participants.  Protocol designs need to consider the
potential for inclusion of intermediaries as protocol participants, what
functions each partipant contributes or depends on, and how the protocol ensures
that limitations on participants are enforced.


## Prefer Services to Intermediaries {#prefer-services}

Entities should not be made protocol participants without good cause.

Where functions can provided by means other than intermediation, this is
preferable.  If there is a need for information, querying a service for that
information is preferable to adding an intermediary. Similarly, direct
invocation of service to perform an action is better than involving that service
as a participant in the protocol.

Involving an entity as an intermediary can greatly increase the degree to which
that entity becomes a dependency.  For example, it might be necessary to
negotiate the use of new capabilities with all protocol participants, including
the intermediary, even when the functions for which the intermediary was added
are not affected.  It is also more difficult to limit the extent to which a
protocol participant can be involved than an adjunct service that is invoked for
a specific task.

Using discrete services is not always the most performant architecture as
additional network interactions can add to overheads.  The cost of these
overheads need to be weighed against the ongoing cost that intermediation might
incur.

This is analogous to the software design principle that recommends a preference
for composition over inheritance {{PATTERNS}}.


## Limit Protocol Participation {#limit-participants}

Protocol participants should have an understanding of what other participants
might be present.

Protocols that permit the involvement of an intermediary need to do so
intentionally and provide measures that prevent the addition of unwanted
intermediaries.  Ideally, all protocol participants are identified and known to
other protocol participants.

The addition of an unwanted protocol participant is an attack on the protocol.

This is an extension of the conclusion of {{?PATH-SIGNALS=RFC8558}}, which:

> recommends that implicit signals should be avoided and that an implicit signal
> should be replaced with an explicit signal only when the signal's originator
> intends that it be used by the network elements on the path.

Where the potential for intermediation already exists, or intermediaries provide
essential functions, the implementation of this principle might require the use
of tools like encryption and authentication protection; see
{{limit-capabilities}}.


## Limit Intermediary Capabilities {#limit-capabilities}

Protocol participants should be able to limit the capabilities conferred to
other protocol participants.

Protocol designs should limit the capabilities and information that protocol
participants are required to confer on other participants. Failing that,
participants should have control over what is conferred.

Limiting the information that participants are required to provide to other
participants has benefits for privacy or to limit the potential for misuse of
information; see {{limit-info}}.  Where confidentiality is impossible or
impractical, integrity protection can be used to ensure that data origin
authentication is preserved; see {{limit-changes}}.


## Limit Information Exposure {#limit-info}

Protocol participants should only have access to the information they need to
perform their designated function.

Protocol designs based on a principle of providing the minimum information
necessary have several benefits.  In addition to requiring smaller messages, or
fewer exchanges, reducing information provides privacy guarantees.

Where an intermediary needs to carry information that it has no need to access,
protocols should use encryption to ensure that the intermediary cannot access
that information.

Moving from a protocol in which there are two participants (such as
{{?TLS=RFC8446}}) to a setting with more than two participants while preserving
confidentiality requires mechanisms that are considerably more complex and
computationally expensive.


## Limit Permitted Interactions {#limit-changes}

Signals generated by protocol participants should be correctly attributed.

Where an intermediary is required to access information, preventing the use of
encryption, integrity protection should be used to prevent modification.

Where an intermediary needs to communicate with other protocol participants,
ensuring that these signals are correctly attributed to the intermediary are
important.

Authentication is the best means of ensuring signals generated by protocol
participants are correctly attributed.  In some cases, particularly protocols
that are primarily two-party protocols, it might be sufficient to allow the
signal to be attributed to _any_ intermediary.  This is the case for the ECN
signal {{?ECN=RFC3168}} or ICMP {{?ICMP=RFC0792}}, both of which are assumed to
be provided by elements on the network path (though limited mechanisms exist to
verify that this is the case for ICMP).


# Applying Non-Technical Constraints

Not all intermediary functions can be tightly constrained.  For instance, as
described in {{incentives}}, some functions involve granting intermediaries
access to information that can be used for more than its intended purpose.
Applying strong technical constraints on how that information is used might be
infeasible or impossible.

The use of authentication allows for other forms of control on intermediaries.
Auditing systems or other mechanisms for ensuring accountability can use
authentication information.  Authentication can also enable the use of legal,
social, or other types of control that might avoid any shortfall in technical
measures.


# The Effect on Existing Practices

The application of these principles can have an effect on existing operational
practices, particularly where they rely on protocols not limiting intermediary
access.  Several documents have explored aspects of this in detail:

* {{?RFC8404}} describes effects of encryption on practices performed by
  intermediaries;

* {{?RFC8517}} describes a broader set of practices;

* {{?TSV-ENC=I-D.ietf-tsvwg-transport-encrypt}} explores the effect on
  transport-layer intermediaries in more detail; and

* {{?NS-IMPACT=I-D.ietf-opsec-ns-impact}} examines the effect of TLS on
  operational network security practices.

In all these documents, the defining characteristic is the move from a system
that lacked controls on participation to one in which technical controls are
deployed.  In each case the protocols in question provided no technical controls
or only limited technical controls that prevent the addition of intermediaries.
This allowed the deployment of techniques that involved the insertion of
intermediaries into sessions without permission or knowledge of other protocol
participants. By adding controls like encryption, these practices are disrupted.
Overall, the advantages derived from having greater control and knowledge of
other protocol participants outweighs these costs.

The process of identifying critical functions for intermediaries is ongoing.
There are three potential classes of outcome of these discussion:

* Practices might be deemed valuable and methods that allow limited
  participation by intermediaries will be added to protocols.

* The use case supported by the practice might be deemed valuable, but
  alternative methods that address the use case without the use of an
  intermediary will be sought.

* Practices might be deemed harmful, so that no replacement mechanism will be
  sought.

Many factors could influence the outcome of this analysis.  For instance,
deployment of alternative methods or limited roles for intermediaries could be
relatively simple for new protocol deployments; whereas it might be challenging
to retrofit controls on existing protocol deployments.


# Security Considerations

Controlling the level of participation and access intermediaries have is in part
a security question.  It is also fundamentally an application of a security
principle: namely the principle of least privilege
{{?LEAST-PRIVILEGE=DOI.10.1145/361011.361067}}.

Lack of proper controls on intermediaries protocols has been the source of
significant security problems.


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments

This document is merely an attempt to codify existing practice.  Practice that
is inspired, at least in part, by prior work, including {{?RFC3552}} and
{{?RFC3724}} which both advocate for clearer articulation of trust boundaries.


