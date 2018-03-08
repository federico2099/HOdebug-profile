      SUBROUTINE mat_Tmat_mul( A , C, SIZE )
   
      INTEGER SIZE
      REAL*4 A( SIZE, SIZE), C( SIZE, SIZE)   
      REAL*4 temp( SIZE, SIZE)   
      INTEGER i, j, k

      write(*,*) size

      DO i = 1, SIZE 
         DO j = 1, SIZE 
            temp( j, i ) = A( i, j )
         END DO
      END DO
   
      DO i = 1, SIZE 
        DO j = 1, SIZE 
           DO k = 1, SIZE 
              C( i, j ) = C( i, j ) + A( i, k ) * temp( k, j )
           END DO
        END DO
      END DO

      write(*,*) "finished"
    
      END SUBROUTINE mat_Tmat_mul
