FC=gfortran 
LN=gfortran
LIBS=lib/geomlib.a lib/mainlib.a 
MODS=lib/geom.mod lib/main.mod

.PHONY: clean chap04 progs
default: p41

all: $(LIBS) $(PROGS)

install: progs libs
# TODO we need an install rule in order to publish the binaries 
#   somewhere on a $PATH. Consider too publishing lib

lib/geomlib.a: library/geom/*.f03
	cd lib &&\
	$(FC) -c ../library/geom/*.f03 && \
	ar -r geomlib.a *.o &&\
	rm *.o

lib/mainlib.a: library/main/*.f03
	cd lib &&\
	$(FC) -c ../library/main/*.f03 &&\
	ar -r mainlib.a *.o &&  rm *.o

# just an individual program
bin/p41: $(LIBS)
	$(FC) -Ilib -o $@ chap04/p41.f03 $(LIBS) 
	
# all prgrams in the whole book
progs: $(LIBS) 
	for i in chap*/*.f03; do \
	  bin=$$(basename $$i .f03); \
	  $(FC) -Ilib $$i $(LIBS) -o bin/$${bin}; \
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
	-rm $(LIBS) $(MODS) bin/*\.*
