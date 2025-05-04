# ResolverV2

**ResolverV2** is the official identity contract powering the Grown Folk decentralized naming system. It allows approved admins to register, transfer, and revoke names like `markus.grownfolk` or `uclick.weship` with verified suffix control. This version was built through real trial and error to enforce structure, reduce errors, and scale to thousands of names across multiple brand and location categories.

---

## Why V2?

The original resolver lacked:
- **Pending request separation** — anyone could front-run a name.
- **Timestamps** — no on-chain record of registration time.
- **Suffix control** — no limit on name endings.
- **Multiple names per user** — no support for brands, aliases, or transfers.

**V2 fixes all of that**, with cleaner admin logic, brand security, and structured suffix verification.

---

## Core Features

- **Admin-Gated Registration**  
  Only verified `approvers` can register names after a user request.

- **Suffix Whitelist**  
  Names must end in an approved `.suffix`—states, cities, and brands only.

- **Name Transfers**  
  Admins can transfer names to new owners (for gifts, org changes, etc).

- **On-Chain Timestamping**  
  Every name registration is saved with a `block.timestamp`.

- **Revocation System**  
  Names can be revoked but never re-registered.

---

## Suffix Types

ResolverV2 supports **over 250+ suffixes**, including:

- **States (50)**: `lansing.michigan`, `austin.texas`
- **Capitals (50)**: `doe.littlerock`, `org.denver`
- **Major Cities (150+)**: `team.anchorage`, `brand.detroit`
- **Brands (11)**:  
  `grownfolk`, `weship`, `uclickweship`, `youngfolk`, `miner`, `yfi`, `gfu`, etc.

Only suffixes hardcoded or added by the owner are allowed.

---

## Key Functions

```solidity
requestName(string calldata name) // Users submit name requests
approveAndRegister(address user, string calldata name) // Admins approve + assign
revokeName(string calldata name) // Admins revoke a name
transferName(string calldata name, address to) // Admins transfer ownership
addApprover(address) / removeApprover(address) // Owner control
addSuffix(string calldata suffix) // Owner adds new suffixes
```

---

## Roles

- **Owner**  
  Can add/remove approvers and allowed suffixes.

- **Approvers**  
  Can register, revoke, and transfer names.

- **Users**  
  Can request names (must include a valid suffix like `.grownfolk`).

---

## Example

```solidity
requestName("markus.grownfolk");
// Approver later calls:
approveAndRegister(msg.sender, "markus.grownfolk");
```

---

## Future Plans

- Public view for all registered names  
- Custom error messages  
- Optional expiration/revalidation window

---

**Live contract and integration examples coming soon.**
