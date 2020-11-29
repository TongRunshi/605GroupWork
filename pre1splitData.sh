#!/bin/bash


nProcessors=10
data="sumbyminute.csv"
nDataLines=$(wc -l < $data)
nLines=$(($nDataLines / $nProcessors))
remainder=$(($nDataLines % $nProcessors))
if [[ $remainder > 0 ]]; then
  nLines=$(($nLines + 1))
fi
split -d -l $nLines $data "$data."
