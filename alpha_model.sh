#!/bin/bash

cat alpha*byminute*.csv >> alpha.csv

Rscript alpha_model.R
