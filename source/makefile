FC=gfortran 
LN=gfortran
LIBS=lib/geomlib.a lib/mainlib.a 
ARPACKLIB=lib/arpacklib.a
MODS=lib/geom.mod lib/main.mod
INSTALL_DIR=..

.PHONY: clean chap04 progs
#default: p41

all: $(LIBS) progs 

install: progs libs
# TODO we need an install rule in order to publish the binaries 
#   somewhere on a $PATH. Consider too publishing lib
	mkdir -p $(INSTALL_DIR)/lib
	cp lib/* $(INSTALL_DIR)/lib
	mkdir -p $(INSTALL_DIR)/bin
	cp lib/* $(INSTALL_DIR)/bin

lib/geomlib.a: library/geom/*.f03
	cd lib &&\
	$(FC) -g -c ../library/geom/*.f03 && \
	ar -r geomlib.a *.o &&\
	rm *.o

lib/mainlib.a: library/main/*.f03
	cd lib &&\
	$(FC) -g -c ../library/main/*.f03 &&\
	ar -r mainlib.a *.o &&  rm *.o

lib/arpacklib.a: lib/libks.f90
	cd lib &&\
	$(FC) -c libks.f90 &&\
	ar -r arpacklib.a *.o  &&  rm *.o

# just an individual program
bin/p41: $(LIBS)
	$(FC) -Ilib -o $@ chap04/p41.f03 $(LIBS) 
# this is broken? elap_time()
# also calls daxpy, ddot
# ie. it relies on a blas library
# nm -a shows that arpacklib.a contains these ??
bin/p57: $(LIBS)
	$(FC) -Ilib -o $@ chap05/p57.f03 $(LIBS) 

# this is mildy broken: double )) in write statements
bin/p113: $(LIBS)
	$(FC) -Ilib -o $@ chap11/p113.f03 $(LIBS) 

# next (and p104) needs lancz1 from arpack which appears here as binary only :-(
bin/p103: $(LIBS) $(ARPACKLIB)
	$(FC) -Ilib -o $@ chap10/p103.f03 $(LIBS) $(ARPACKLIB)
	
# all prgrams in the whole book
progs: $(LIBS) 
	for i in chap*/*.f03; do \
	  bin=$$(basename $$i .f03); \
	  $(FC) -g -Ilib $$i $(LIBS) -o bin/$${bin}; \
	done
	
# all programs in one chapter
chap04: $(LIBS) 
	for i in chap04/*.f03; do \
	  bin=$$(basename $$i .f03); \
	  $(FC) -Ilib $$i $(LIBS) -o bin/$${bin}; \
	done
	
clean:

# This removes everything build. Noote how we presreve bin/README.md
distclean: clean
	-rm $(LIBS) $(ARPACKLIB) $(MODS)
