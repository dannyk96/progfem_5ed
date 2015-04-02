
## List of Errata found in the published programs from the book

A small number of problems were found with building and running the programs.

  #     | Problem | Sttaus    |    Summary   |
:-------:|---------|----------|--------------|
   1    | segv crashes in p44 etc. |patched   | need to add _USE geom_ after _USE main_ . Cause was due to a change from which library __formnf()__ was kepy in
   2    | p57 calls ddot etc. | to fix | Looks like this implicitly needs BLAS eg Intel MKL
   3    | p57 calls elap_time() | to fix | elap_time() is not found anywhere else in this suite. Looks like it is a simple call to a wallclock timer?

   1  Segment violation in p44

These are the list of files where "USE geom" does not exist.

One oddity is that __p42__ appeared to run in spite of the bug.
```
$ find chap* -name \*.f03  |xargs grep -iL "USE geom"
chap04/p42.f03
chap04/p44.f03
chap04/p45.f03
chap07/p71.f03
chap08/p82.f03
chap08/p83.f03
chap08/p81.f03
```

Of these the following also call formnf:
```
$ find chap* -name \*.f03  |xargs grep -iL "USE geom" |xargs grep -i formnf
chap04/p42.f03: CALL formnf(nf)
chap04/p44.f03: CALL formnf(nf)
chap04/p45.f03: CALL formnf(nf)
```

Of the remaining:
__p71.f03__ is 1D fluid flow. Only the two ends are boundary conditions so no nf() array

__p81.f03__, __p82.f03__, __p83.f03__  Again all 1D problems - no 2d or 3d mesh and so no node freedom array nf().

So these do not need patching.

A suitable patch is here:

``` diff
diff -cw chap04.orig/p42.f03 chap04/p42.f03
*** chap04.orig/p42.f03 2007-05-09 18:54:14.000000000 +0100
--- chap04/p42.f03      2015-04-02 15:33:12.324767661 +0100
***************
*** 5,10 ****
--- 5,11 ----
  !             elements in 2- or 3-dimensions
  !-------------------------------------------------------------------------
   USE main
+  USE geom
   IMPLICIT NONE
   INTEGER,PARAMETER::iwp=SELECTED_REAL_KIND(15)
   INTEGER::fixed_freedoms,i,iel,k,loaded_nodes,ndim,ndof=2,nels,neq,nod=2, &
diff -cw chap04.orig/p44.f03 chap04/p44.f03
*** chap04.orig/p44.f03 2007-05-09 19:05:34.000000000 +0100
--- chap04/p44.f03      2015-04-02 09:42:06.216305890 +0100
***************
*** 5,10 ****
--- 5,11 ----
  !             beam/rod elements in 2- or 3-dimensions.
  !-------------------------------------------------------------------------
   USE main
+  USE geom
   IMPLICIT NONE
   INTEGER,PARAMETER::iwp=SELECTED_REAL_KIND(15)
   INTEGER::fixed_freedoms,i,iel,k,loaded_nodes,ndim,ndof,nels,neq,nod=2,   &
diff -cw chap04.orig/p45.f03 chap04/p45.f03
*** chap04.orig/p45.f03 2007-05-09 19:06:32.000000000 +0100
--- chap04/p45.f03      2015-04-02 09:42:21.696382672 +0100
***************
*** 6,11 ****
--- 6,12 ----
  !             3-dimensions
  !-------------------------------------------------------------------------
   USE main
+  USE geom
   IMPLICIT NONE
   INTEGER,PARAMETER::iwp=SELECTED_REAL_KIND(15)
   INTEGER::i,iel,incs,iters,iy,k,limit,loaded_nodes,ndim,ndof,nels,neq,    &

```

__Note__: the datestamps on the original files show that they are 2007 which predated the 2013 new edition of this book :-)


2. ddot in p57

3. elap_time() in p57

Google shows that this routine is found in __Parafem__ o
see  https://searchcode.com/codesearch/view/11880409/

Suspect that this is form the module:
``` Fortran
USE timing 
```

__Note:__  Although p57.dat and p57.f03 appears in the distribution, the compiled p57.exe does not!

The full list of calls from p57 are:
``` fortran
$ grep -i call chap05/p57.f03
 CALL getname(argv,nlen)
 CALL mesh_size(element,nod,nels,nn,nxe,nye,nze)
 CALL formnf(nf)
 CALL sample(element,points,weights)
   CALL hexahedron_xz(iel,x_coords,y_coords,z_coords,coord,num)
   CALL num_to_g(num,nf,g)
   CALL umat(sigma,statev,dee,sse,spd,scd,rpl,ddsddt,drplde,              &
     CALL shape_der(der,points,i)
     CALL invert(jac)
     CALL beemat(bee,deriv)
 CALL mesh_ensi(argv,nlen,g_coord,g_num,element,etype,nf,oldlds(1:),      &
   CALL dsymm('L','l',ndof,nels,one,km,ndof,g_pmul,ndof,one,g_utemp,ndof)
   CALL daxpy(neq,alpha,p,1,xnew,1)
   CALL daxpy(neq,alpha,u,1,loads,1)
   CALL checon(xnew,x,cg_tol,cg_converged)
 CALL dismsh_ensi(argv,nlen,nstep,nf,xnew(1:))
 CALL sample(element,points,weights)
   CALL umat(sigma,statev,dee,sse,spd,scd,rpl,ddsddt,drplde,              &
     CALL shape_der(der,points,i)
     CALL shape_fun(fun,points,i)
     CALL invert(jac)
     CALL beemat(bee,deriv)
```
of which these appear to be of interest
``` fortran
 CALL getname(argv,nlen)
 CALL mesh_ensi(argv,nlen,g_coord,g_num,element,etype,nf,oldlds(1:),      &
   CALL dsymm('L','l',ndof,nels,one,km,ndof,g_pmul,ndof,one,g_utemp,ndof)
   CALL daxpy(neq,alpha,p,1,xnew,1)
   CALL daxpy(neq,alpha,u,1,loads,1)
 CALL dismsh_ensi(argv,nlen,nstep,nf,xnew(1:))
```
