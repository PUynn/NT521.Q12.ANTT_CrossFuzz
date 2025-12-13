#!/bin/bash

SOLC_VERSION="0.4.26"
MAX_LEN=5
TIMEOUT=120
SOLC_PATH="/home/pu/CrossFuzz/myenv/bin/solc"
MODE="auto"
DUPLICATION=0
OUTDIR="fuzzer/result_crossfuzz"


# ------------------------------
# WALLET
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xcead721ef5b11f1a7b530171aab69b16c5e66b6e.sol WALLET \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xcead721ef5b11f1a7b530171aab69b16c5e66b6e.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# PRIVATE_ETH_CELL
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x4e73b32ed6c35f570686b89848e5f39f20ecc106.sol PRIVATE_ETH_CELL \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x4e73b32ed6c35f570686b89848e5f39f20ecc106.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# BANK_SAFE
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x561eac93c92360949ab1f1403323e6db345cbf31.sol BANK_SAFE \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x561eac93c92360949ab1f1403323e6db345cbf31.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# PERSONAL_BANK
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x01f8c4e3fa3edeb29e514cba738d87ce8c091d3f.sol PERSONAL_BANK \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x01f8c4e3fa3edeb29e514cba738d87ce8c091d3f.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# TokenBank
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839.sol TokenBank \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# MONEY_BOX
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888.sol MONEY_BOX \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# U_BANK
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x7541b76cb60f4c60af330c208b0623b7f54bf615.sol U_BANK \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x7541b76cb60f4c60af330c208b0623b7f54bf615.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# ETH_VAULT
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x8c7777c45481dba411450c228cb692ac3d550344.sol ETH_VAULT \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x8c7777c45481dba411450c228cb692ac3d550344.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# ETH_FUND
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x941d225236464a25eb18076df7da6a91d0f95e9e.sol ETH_FUND \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x941d225236464a25eb18076df7da6a91d0f95e9e.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# PrivateDeposit
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x7a8721a9d64c74da899424c1b52acbf58ddc9782.sol PrivateDeposit \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x7a8721a9d64c74da899424c1b52acbf58ddc9782.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# X_WALLET
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x93c32845fae42c83a70e5f06214c8433665c2ab5.sol X_WALLET \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x93c32845fae42c83a70e5f06214c8433665c2ab5.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# Private_Bank
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xb5e1b1ee15c6fa0e48fce100125569d430f1bd12.sol Private_Bank \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xb5e1b1ee15c6fa0e48fce100125569d430f1bd12.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# ACCURAL_DEPOSIT
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x4320e6f8c05b27ab4707cd1f6d5ce6f3e4b3a5a1.sol ACCURAL_DEPOSIT \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x4320e6f8c05b27ab4707cd1f6d5ce6f3e4b3a5a1.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# ETH_VAULT (duplicate name, different file)
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xbaf51e761510c1a11bf48dd87c0307ac8a8c8a4f.sol ETH_VAULT \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xbaf51e761510c1a11bf48dd87c0307ac8a8c8a4f.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# PrivateBank (two contracts)
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x23a91059fdc9579a9fbd0edc5f2ea0bfdb70deb4.sol PrivateBank \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x23a91059fdc9579a9fbd0edc5f2ea0bfdb70deb4.json \
  $SOLC_PATH $MODE $DUPLICATION

python3 CrossFuzz.py contracts_xfuzz/0xb93430ce38ac4a6bb47fb1fc085ea669353fd89e.sol PrivateBank \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xb93430ce38ac4a6bb47fb1fc085ea669353fd89e.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# W_WALLET
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x7b368c4e805c3870b6c49a3f1f49f69af8662cf3.sol W_WALLET \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x7b368c4e805c3870b6c49a3f1f49f69af8662cf3.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# DEP_BANK
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8.sol DEP_BANK \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# PENNY_BY_PENNY
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0x96edbe868531bd23a6c05e9d0c424ea64fb1b78b.sol PENNY_BY_PENNY \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0x96edbe868531bd23a6c05e9d0c424ea64fb1b78b.json \
  $SOLC_PATH $MODE $DUPLICATION

# ------------------------------
# MY_BANK
# ------------------------------
python3 CrossFuzz.py contracts_xfuzz/0xf015c35649c82f5467c9c74b7f28ee67665aad68.sol MY_BANK \
  $SOLC_VERSION $MAX_LEN $TIMEOUT \
  $OUTDIR/0xf015c35649c82f5467c9c74b7f28ee67665aad68.json \
  $SOLC_PATH $MODE $DUPLICATION

echo "===== CrossFuzz fuzzing finished ====="

