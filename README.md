# GrownFolkResolverV2

**GrownFolkResolverV2** is the official on-chain name registry for `.grownfolk`, `.weship`, `.youngfolk`, and location-based suffixes like `.detroit`, `.nyc`, and `.atlanta`. It powers verified identity, profile resolution, and decentralized naming for Grown Folk United and its Web3 network.

## Purpose

This contract provides verified, on-chain naming with geographic, brand, and user-defined identities. It limits abuse by allowing only pre-approved suffixes and admin-controlled registration.

## Features

- **Only Admins Can Approve**: Name registration requires approver action after request.
- **Multi-Name Support**: Each wallet can hold multiple names.
- **Timestamped Proof**: `nameTimestamps` log the exact time of name approval.
- **Transfer + Revocation**: Admins can transfer or revoke names if needed.
- **Suffix Whitelist**: Includes all 50 U.S. states, 50 capitals, 150 major cities, and brand names.
- **Name Requests**: Users submit requests before approval.

## Major Improvements Over V1

| Problem in V1                  | Fix in V2                                                  |
|-------------------------------|-------------------------------------------------------------|
| One-name limit per wallet     | Added full `string[]` support for wallet → name mapping     |
| No timestamp tracking         | `nameTimestamps[name] = block.timestamp` added              |
| No city or capital support    | 250+ verified suffixes now included                         |
| No way to track requests      | `pendingRequests[wallet]` lets users see pending requests   |
| No suffix validation          | All names must end in approved `.suffix`                    |
| No admin controls             | Admin-only modifiers added for safety and transferability   |

## Example Use Cases

- `markminer.grownfolk` — Verified organizer profile
- `detroit.michigan` — Regional identity
- `uclick.weship` — Brand-verified business
- `atlanta.georgia` — Local chapter or hub

## Events

```solidity
event NameRequested(address indexed user, string name);
event NameRegistered(address indexed user, string name);
event NameRevoked(string name);
event NameTransferred(string name, address from, address to);
event ApproverAdded(address approver);
event ApproverRemoved(address approver);
```

## Powered by Grown Folk ID

This contract powers the Grown Folk ID system — a decentralized identity network for real-world organizers, businesses, and communities.

Every `.grownfolk` name issued through this system is manually approved and timestamped on-chain, allowing for:

- Verified organizer profiles  
- Regional identity (e.g. `detroit.michigan`)  
- Brand-backed entities (e.g. `uclick.weship`)  
- Local chapters (e.g. `atlanta.georgia`)  

Grown Folk Resolver V2 was built through trial and error — improving on V1 by separating pending names, timestamping approvals, and allowing city, state, and brand-based suffixes.

> **Grown Folk ID** — where profiles come before coins.
