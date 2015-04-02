#!/bin/bash

#
#
#
#
BIN=/home/dan/git/progfem_5ed/source/bin/

all:
	for i in chap*/*.dat; do \
          base=$$(basename $$i .dat);\
	  root=`echo $$i|cut -f1 -d.`;\
	  bin=`echo $$base|cut -f1 -d_`; \
	  echo -n "running: $$bin $$root" ;\
	  /usr/bin/time -f "\t%E real" sh -c "($(BIN)/$$bin $$root 2>$$root.err > $$root.log)";\
	done


# collect together the data for the table

# write table header
echo     Chapter  | Prog.  |datfile  | errcode  | .res sie  | stdout siize |stderr size
echo  ------------|--------|---------|----------|-----------|--------------|------------
