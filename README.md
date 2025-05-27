# Stacks Escrow Smart Contract

A secure and decentralized escrow smart contract built for the Stacks blockchain, enabling safe peer-to-peer transactions between buyers and sellers.

## Features

- ✅ Secure STX deposit mechanism
- 🔒 Two-party approval system
- 💫 Automated fund release
- 📊 Deposit status tracking

## Contract Functions

### `deposit`
Allows the buyer to deposit STX into escrow.
```clarity
(define-public (deposit (amount uint)))
```
- Requires: Sender must be buyer
- Validates: Single deposit only
- Ensures: Amount > 0

### `approve`
Enables both parties to approve the transaction.
```clarity
(define-public (approve))
```
- Accessible by: Buyer and seller only
- State: Updates approval status for respective party

### `release`
Releases funds to seller upon dual approval.
```clarity
(define-public (release))
```
- Requires: Both parties' approval
- Action: Transfers STX to seller
- Resets: Deposit amount after transfer

### `get-deposit`
View current deposit status.
```clarity
(define-read-only (get-deposit))
```
- Returns: Current deposited amount

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Invalid sender (not buyer) |
| u101 | Multiple deposit attempt |
| u103 | Invalid approval sender |
| u104 | Release without approval |
| u105 | Invalid deposit amount |


## Security

- Contract ensures atomic transactions
- Implements proper validation checks
- Uses secure STX transfer mechanisms
- Prevents multiple deposits

