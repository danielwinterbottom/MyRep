#!/bin/sh

# Quickly compare two datacards using the DatacardCompare tool.
# The [channel] and [mode] should be specified as one of:
#
# eleTau 	0
# muTau 	1
# emu			2
#
# [output] is a string which will be added to the name of a pdf file containing a
# comparison of each shape for a given category, e.g.
#
# output/dc_sync/compare_vbf_[output].pdf
#
# Note that the folder output/dc_sync must already exist for the writing of this
# pdf file to be successful.
# 
# The option [show_error_bars] controls whether or not the statistical error bars
# on the templates will be drawn.
# [label1] and [label2] identify the two inputs, both on the screen where a table
# of yields will be printed, and in the legends of the comparison plots.

# Warning: the first comparison of the inclusive category may fail when using
# inputs produced by other frameworks, as this category is not mandatory in the 
# analysis

if (( "$#" != "8" ))
then
  echo "Usage: compare_dcs.sh [channel] [mode] [file1] [file2] [output] [show_error_bars <0,1>] [label1] [label2]"
  exit
fi

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_inclusive --output_file=output/dc_sync/compare_inclusive_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_vbf --output_file=output/dc_sync/compare_vbf_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_vbf_loose --output_file=output/dc_sync/compare_vbf_loose_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_vbf_tight --output_file=output/dc_sync/compare_vbf_tight_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_1jet_high_mediumhiggs --output_file=output/dc_sync/compare_1jet_high_mediumhiggs_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_1jet_high_lowhiggs --output_file=output/dc_sync/compare_1jet_high_lowhiggs_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_1jet_medium --output_file=output/dc_sync/compare_1jet_medium_$5.pdf      

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_0jet_high --output_file=output/dc_sync/compare_0jet_high_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_0jet_medium --output_file=output/dc_sync/compare_0jet_medium_$5.pdf

./bin/DatacardCompare --mode=$2 --inputs $3 $4  \
--labels $7 $8  --show_errs=$6 --category "$1"_0jet_low --output_file=output/dc_sync/compare_0jet_low_$5.pdf

TMPFILES=""

for i in {1..12}
do
  gs -q -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$i -dLastPage=$i -sOutputFile=compare_tmp_$i.pdf output/dc_sync/compare_*_$5.pdf > /dev/null 2>&1
  TMPFILES=$TMPFILES" compare_tmp_$i.pdf"
done

gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=compare_$5.pdf $TMPFILES
rm compare_tmp_*.pdf
