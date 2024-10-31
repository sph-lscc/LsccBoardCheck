#!/bin/sh

# Setup
if [ $(uname) = 'Darwin' ] ; then
  VERILATOR_ROOT=/opt/homebrew
  CORES=`sysctl -n hw.ncpu`
else
  VERILATOR_ROOT=/opt/verilator
  CORES=`nproc`
fi

# Set Parameters
BOARDS="ATE_EVAL ATG_VERSA CPNX_VERSA XO5_EVAL XO5T_EVAL XO3_DEVBRD XO2_BRKOUTBRD"

# Compile
for BRD in $BOARDS
do
  echo "\n-----------------"
  echo "Board: $BRD"
  echo "-----------------"

  $VERILATOR_ROOT/bin/verilator -threads $CORES --timing -f sim_$BRD.opt ;

done
