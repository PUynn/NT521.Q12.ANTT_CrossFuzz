#!/bin/bash

# ==============================
# ConFuzzius fuzzing_script
# ==============================

SOLC_VERSION="v0.4.26"
EVM_VERSION="byzantium"
MAX_LEN=10
T=300
OUTDIR="fuzzer/result2"

mkdir -p $OUTDIR

# 1) Assertion failure : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/1_assertion_failure.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/1_assertion_failure.json \


# 2) Block dependency : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/2_block_dependency.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/2_block_dependency.json \

# 3) Integer overflow : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/3_integer_overflow.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/3_integer_overflow.json \

# 4) Leaking ether : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/4_leaking_ether.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/4_leaking_ether.json \

# 5) Locking ether : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/5_locking_ether.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/5_locking_ether.json \

# 6) Reentrancy : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/6_reentrancy.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/6_reentrancy.json \


# 7) Transaction order dependency : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/7_transaction_order_dependency.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/7_transaction_order_dependency.json \


# 8) Unhandled exception : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/8_unhandled_exception.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/8_unhandled_exception.json \


# 9) Unprotected selfdestruct : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/9_unprotected_selfdestruct.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/9_unprotected_selfdestruct.json \


# 10) Unsafe delegatecall : Driver
python3 fuzzer/main.py \
  -s contract_10vuln/10_unsafe_delegatecall.sol -c Driver \
  --solc $SOLC_VERSION --evm $EVM_VERSION \
  --max-individual-length $MAX_LEN \
  -t $T \
  --seed 1 \
  --data-dependency 0 \
  --constraint-solving 0 \
  --environmental-instrumentation 0 \
  -r $OUTDIR/10_unsafe_delegatecall.json \


echo "===== Done. Results saved in $OUTDIR ====="

