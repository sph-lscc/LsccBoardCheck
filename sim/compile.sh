#!/bin/sh

# Setup
if [ $(uname) = 'Darwin' ] ; then
  VERILATOR_ROOT=/opt/homebrew
  CORES=`sysctl -n hw.ncpu`
else
  VERILATOR_ROOT=/opt/verilator
  CORES=`nproc`
fi


# Set Parameters (Ignore XO2_BRKOUTBRD - Need PMI compiling to library)
BOARDS="ATE_EVAL ATG_VERSA CPNX_VERSA XO5_EVAL XO5T_EVAL XO3_DEVBRD"

for BRD in $BOARDS
do

  echo "\n-----------------"
  echo "Board: $BRD"
  echo "-----------------"
  $VERILATOR_ROOT/bin/verilator -threads $CORES -GBOARD=\"$BRD\" -f sim.opt
done
