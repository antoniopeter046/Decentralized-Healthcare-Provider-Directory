# Decentralized Healthcare Provider Directory

A blockchain-based solution for managing healthcare provider information using Clarity smart contracts.

## Overview

This project implements a decentralized healthcare provider directory that allows for transparent, secure, and efficient management of healthcare provider information. The system uses Clarity smart contracts to store and verify provider credentials, specialties, practice locations, and insurance network affiliations.

## Key Features

- **Provider Verification**: Validates healthcare practitioners' credentials and licenses
- **Specialty Certification**: Records and verifies medical expertise and board certifications
- **Practice Location**: Tracks service delivery sites with detailed information
- **Network Participation**: Records insurance network affiliations and contract details
- **Directory Access Control**: Manages information retrieval with configurable access levels

## Smart Contracts

### Provider Verification Contract

Manages the registration and verification of healthcare providers:

- Provider registration with credentials and license information
- Verification process by authorized administrators
- Status tracking (pending, verified, revoked)

### Specialty Certification Contract

Tracks medical specialties and board certifications:

- Records specialty certifications with expiration dates
- Validates certification data
- Tracks certification status (active, expired, revoked)

### Practice Location Contract

Manages provider practice locations:

- Stores detailed location information (address, contact details)
- Tracks services offered at each location
- Supports primary location designation

### Network Participation Contract

Records insurance network affiliations:

- Tracks payer relationships and contract details
- Manages effective and termination dates
- Supports network tier information

### Directory Access Contract

Controls access to directory information:

- Configurable access levels (public, restricted, private)
- User authorization management
- Centralized query interface for all provider data

## Testing

The project includes comprehensive tests using Vitest:

- Unit tests for each contract
- Mock implementations for testing contract interactions
- Validation of access control mechanisms

## Getting Started

1. Clone the repository
2. Run tests: `npm test`
3. Deploy contracts to a Stacks blockchain node

## Usage Examples

### Registering a Provider

```clarity
(contract-call? .provider-verification register-provider 
  "provider123" 
  "Dr. John Doe" 
  "MD12345" 
  "NY" 
  "1234567890")
