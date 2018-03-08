program test

  implicit none

! Show cache influence on code performances
! "good" loop sums matrixes in column order (best)
! "bad" loop sums matrixes in row order
! Test
! 1 - ifort test_gprof1.f90 -O3
!    --> good loop performs surely better (not interchanging on bad loop, despite
!        to man ifort 
! 2 - ifort test_gprof1.f90 -O3 -xW
!    --> compiler performs interchange to bad loop, better performances

  real, allocatable :: a(:,:), b(:,:), c(:,:)
  real alpha 
  integer i, j, dim, niter, t

  dim = 5000
  niter = 2
  alpha = sqrt(1.)

  allocate(a(dim, dim))
  allocate(b(dim, dim))
  allocate(c(dim, dim))

  a = 0.
  b = 1.
  c = 2.
!!!!!!!!!!!!!!!!!!!!!!!!! BAD START !!!!!!!!!!!!!!!!!!!!!!!
  write(*,*) "bad start"

  do t=1, niter

     do j=1, dim
        do i=1, dim
           a(j,i) = a(j,i) + b(j,i) + c(j,i) + alpha
        enddo
     enddo

  enddo
  write(*,*) "bad end"
!!!!!!!!!!!!!!!!!!!!!!!!! BAD END !!!!!!!!!!!!!!!!!!!!!!!

  deallocate(a)
  deallocate(b)
  deallocate(c)

end program test
