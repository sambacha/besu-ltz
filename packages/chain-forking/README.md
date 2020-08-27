Each node maintains the following values:

FORK_HASH: IEEE CRC32 checksum ([4]byte) of the genesis hash and fork blocks numbers that already passed.
The fork block numbers are fed into the CRC32 checksum in ascending order.
If multiple forks are applied at the same block, the block number is checksummed only once.
Block numbers are regarded as uint64 integers, encoded in big endian format when checksumming.
If a chain is configured to start with a non-Frontier ruleset already in its genesis, that is NOT considered a fork.
FORK_NEXT: Block number (uint64) of the next upcoming fork, or 0 if no next fork is known.
E.g. FORK_HASH for mainnet would be:

forkhash₀ = 0xfc64ec04 (Genesis) = CRC32(<genesis-hash>)
forkhash₁ = 0x97c2c34c (Homestead) = CRC32(<genesis-hash> || uint64(1150000))
forkhash₂ = 0x91d1f948 (DAO fork) = CRC32(<genesis-hash> || uint64(1150000) || uint64(1920000))
The fork identifier is defined as RLP([FORK_HASH, FORK_NEXT]). This forkid is cross validated (NOT naively compared) to assess a remote chain’s compatibility. Irrespective of fork state, both parties must come to the same conclusion to avoid indefinite reconnect attempts from one side.

echo -n "0xfc64ec04" | cksum | cut -d\ -f1 | xargs echo printf '%0X\\n' | sh# `chain-forking`

> TODO: description

## Usage

```
const chainForking = require('chain-forking');

// TODO: DEMONSTRATE API
```
