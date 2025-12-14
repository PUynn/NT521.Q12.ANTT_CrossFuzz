#!/bin/bash

SOLC_VERSION="0.4.26"
N=10
T=300
SOLC_PATH="/home/pu/CrossFuzz/myenv/bin/solc"
MODE="auto"
DUPLICATION=0
OUTDIR="fuzzer/result2"

mkdir -p $OUTDIR

# 1) Assertion failure : Driver
python3 CrossFuzz.py contract_10vuln/1_assertion_failure.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/1_assertion_failure.json \
  $SOLC_PATH $MODE $DUPLICATION

# 2) Block dependency : SurveyEngine
python3 CrossFuzz.py contract_10vuln/2_block_dependency.sol SurveyEngine \
  $SOLC_VERSION $N $T \
  $OUTDIR/2_block_dependency.json \
  $SOLC_PATH $MODE $DUPLICATION

# 3) Integer overflow : TokenLedger
python3 CrossFuzz.py contract_10vuln/3_integer_overflow.sol TokenLedger \
  $SOLC_VERSION $N $T \
  $OUTDIR/3_integer_overflow.json \
  $SOLC_PATH $MODE $DUPLICATION

# 4) Leaking ether : Driver
python3 CrossFuzz.py contract_10vuln/4_leaking_ether.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/4_leaking_ether.json \
  $SOLC_PATH $MODE $DUPLICATION

# 5) Locking ether : Driver
python3 CrossFuzz.py contract_10vuln/5_locking_ether.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/5_locking_ether.json \
  $SOLC_PATH $MODE $DUPLICATION

# 6) Reentrancy : Driver
python3 CrossFuzz.py contract_10vuln/6_reentrancy.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/6_reentrancy.json \
  $SOLC_PATH $MODE $DUPLICATION

# 7) Transaction order dependency : Exchange
python3 CrossFuzz.py contract_10vuln/7_transaction_order_dependency.sol Exchange \
  $SOLC_VERSION $N $T \
  $OUTDIR/7_transaction_order_dependency.json \
  $SOLC_PATH $MODE $DUPLICATION

# 8) Unhandled exception : Driver
python3 CrossFuzz.py contract_10vuln/8_unhandled_exception.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/8_unhandled_exception.json \
  $SOLC_PATH $MODE $DUPLICATION

# 9) Unprotected selfdestruct : Driver
python3 CrossFuzz.py contract_10vuln/9_unprotected_selfdestruct.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/9_unprotected_selfdestruct.json \
  $SOLC_PATH $MODE $DUPLICATION

# 10) Unsafe delegatecall : Driver

python3 CrossFuzz.py contract_10vuln/10_unsafe_delegatecall.sol Driver \
  $SOLC_VERSION $N $T \
  $OUTDIR/10_unsafe_delegatecall.json \
  $SOLC_PATH $MODE $DUPLICATION

echo "===== Done. Results saved in $OUTDIR ====="

