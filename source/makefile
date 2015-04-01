FC=gfortran 
LN=gfortran
LIBS=lib/geomlib.a lib/mainlib.a 
MODS=lib/geom.mod lib/main.mod

.PHONY: clean chap04
default: p41

all: geomlib.a mainlib.a apps

lib/geomlib.a:
	cd lib &&\
	$(FC) -c ../library/geom/*.f03 && \
	ar -r geomlib.a ../library/geom/*.o &&\
	rm *.o

lib/mainlib.a:
	cd lib &&\
	$(FC) -c ../library/main/*.f03 &&\
	ar -r mainlib.a ../library/main/*.o &&  rm *.o

p41: $(LIBS)
	$(FC) -Ilib -o $@ chap04/p41.f03 $(LIBS) 
	
chap04: $(LIBS) 
	for i in chap04/*.f03; do \
	  $(FC) -Ilib $$i $(LIBS); \
	done
	
clean:
	-rm  lib/*.o 
veryclean: clean
	-rm $(LIBS) $(MODS)
