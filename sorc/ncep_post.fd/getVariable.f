!!!@PROCESS NOEXTCHK
subroutine getVariable(fileName,DateStr,dh,VarName,VarBuff,IM,JSTA_2L,JEND_2U,LM,IM1,JS,JE,LM1)


!     SUBPROGRAM DOCUMENTATION BLOCK
!                .      .    .
! SUBPROGRAM:    getVariable    Read data from WRF output
!   PRGRMMR: MIKE BALDWIN    ORG: NSSL/SPC   DATE: 2002-04-08
!
! ABSTRACT:  THIS ROUTINE READS DATA FROM A WRF OUTPUT FILE
!   USING WRF I/O API.
!   .
!
! PROGRAM HISTORY LOG:
!
!  Date      |  Programmer   | Comments
! -----------|---------------|---------
! 2024-08-06 | Jaymes Kenyon | Read-in netCDF fill values for MPAS applications
! 2024-09-05 | Jaymes Kenyon | Limiting write statements to process 0 only
!
! USAGE:    CALL getVariable(fileName,DateStr,dh,VarName,VarBuff,IM,JSTA_2L,JEND_2U,LM,IM1,JS,JE,LM1)
!
!   INPUT ARGUMENT LIST:
!     fileName : Character(len=256) : name of WRF output file
!     DateStr  : Character(len=19)  : date/time of requested variable
!     dh :  integer                 : data handle
!     VarName :  Character(len=31)  : variable name
!     IM :  integer  : X dimension of data array
!     JSTA_2L :  integer  : start Y dimension of data array
!     JEND_2U :  integer  : end Y dimension of data array
!     LM :  integer  : Z dimension of data array
!     IM1 :  integer  : amount of data pulled in X dimension 
!     JS :  integer  : start Y dimension of amount of data array pulled
!     JE :  integer  : end Y dimension of amount of data array pulled
!     LM1 :  integer  : amount of data pulled in Z dimension
!
!   data is flipped in the Z dimension from what is originally given
!   the code requires the Z dimension to increase with pressure
!
!   OUTPUT ARGUMENT LIST:
!     VarBuff : real(IM,JSTA_2L:JEND_2U,LM) : requested data array
!
!   OUTPUT FILES:
!     NONE
!
!   SUBPROGRAMS CALLED:
!     UTILITIES:
!       NONE
!     LIBRARY:
!       WRF I/O API
!       NETCDF

 ! This subroutine reads the values of the variable named VarName into the buffer
 ! VarBuff. VarBuff is filled with data only for I=1,IM1 and for J=JS,JE
 ! and for L=1,Lm1, presumably this will be
 ! the portion of VarBuff that is needed for this task.
 !  use mpi
   use wrf_io_flags_mod, only: wrf_real, wrf_real8
   use ctlblk_mod, only: me, spval, submodelname
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   implicit none

   INCLUDE "mpif.h"

!
   character(len=256) ,intent(in) :: fileName
   character(len=19) ,intent(in) :: DateStr
   integer ,intent(in) :: dh
   character(*) ,intent(in) :: VarName
   real,intent(out) :: VarBuff(IM,JSTA_2L:JEND_2U,LM)
   integer,intent(in) :: IM,LM,JSTA_2L,JEND_2U
   integer,intent(in) :: IM1,LM1,JS,JE
   integer :: ndim
   integer :: WrfType,i,j,l,ll
   integer, dimension(4) :: start_index, end_index
   character (len= 4) :: staggering
   character (len= 3) :: ordering
   character (len=80), dimension(3) :: dimnames
   real, allocatable, dimension(:,:,:,:) :: data
   integer :: ierr,size,mype,idsize,ier
   character(len=132) :: Stagger
   real :: FillValue
   integer :: OutCount

!    call set_wrf_debug_level ( 1 )
   call mpi_comm_rank(MPI_COMM_WORLD,mype,ier)
   start_index = 1
   end_index = 1
!   print*,'SPVAL in getVariable = ',SPVAL
   call ext_ncd_get_var_info(dh,TRIM(VarName),ndim,ordering,Stagger,start_index,end_index,WrfType,ierr)
   IF ( ierr /= 0 ) THEN
     if (me==0) write(*,*)'Error: ',ierr,TRIM(VarName),' not found in ',fileName
     VarBuff=0.  
     return
   ENDIF
   allocate(data (end_index(1), end_index(2), end_index(3), 1))
   if( WrfType /= WRF_REAL .AND. WrfType /= WRF_REAL8 ) then !Ignore if not a real variable
     if (me==0) write(*,*) 'Error: Not a real variable',WrfType
     return
   endif
!  write(*,'(A9,1x,I1,3(1x,I3),1x,A,1x,A)')&
!           trim(VarName), ndim, end_index(1), end_index(2), end_index(3), &
!           trim(ordering), trim(DateStr)
!   allocate(data (end_index(1), end_index(2), end_index(3), 1))
!   call ext_ncd_read_field(dh,DateStr,TRIM(VarName),data,WrfType,0,0,0,ordering,&
! CHANGE WrfType to WRF_REAL BECAUSE THIS TELLS WRF IO API TO CONVERT TO REAL
!          print  *,' GWVX XT_NCD GET FIELD',size(data), size(varbuff),mype
     idsize=size(data)
   if(mype == 0) then
   call ext_ncd_read_field(dh,DateStr,TRIM(VarName),data,WrfType,0,0,0,ordering,&
                             staggering, dimnames , &
                             start_index,end_index, & !dom 
                             start_index,end_index, & !mem
                             start_index,end_index, & !pat
                             ierr)
    endif
     call MPI_BCAST(data,idsize,MPI_real,0,MPI_COMM_WORLD,ierr) 
   IF ( ierr /= 0 ) THEN
     if (me==0) then
       write(*,*)'Error reading ',Varname,' from ',fileName
       write(*,*)' ndim = ', ndim
       write(*,*)' end_index(1) ',end_index(1)
       write(*,*)' end_index(2) ',end_index(2)
       write(*,*)' end_index(3) ',end_index(3)
     endif
     VarBuff = 0.0
     return
   ENDIF

   if (me==0) then
     if (im1>end_index(1)) write(*,*) 'Err:',Varname,' IM1=',im1,&
                  ' but data dim=',end_index(1)
     if (je>end_index(2)) write(*,*) 'Err:',Varname,' JE=',je,&
                  ' but data dim=',end_index(2)
     if (lm1>end_index(3)) write(*,*) 'Err:',Varname,' LM1=',lm1,&
                  ' but data dim=',end_index(3)
     if (ndim>3) then
       write(*,*) 'Error: ndim = ',ndim
     endif 
   endif 

   if (SUBMODELNAME=='MPAS') then
   ! For MPAS: determine the fill value associated with the variable
     call ext_ncd_get_var_ti_real(dh,"_FillValue",TRIM(VarName),FillValue,1,OutCount,ierr)
     do l=1,lm1
       ll=lm1-l+1  ! flip the z axis not sure about soil
       do i=1,im1
        do j=js,je
          if (data(i,j,ll,1) /= FillValue) then
            VarBuff(i,j,l)=data(i,j,ll,1)
          else ! For MPAS: assign SPVAL where FillValue is present
            VarBuff(i,j,l)=spval
          endif
        enddo
       enddo
     enddo
   else
     do l=1,lm1
       ll=lm1-l+1  ! flip the z axis not sure about soil
       do i=1,im1
        do j=js,je
         VarBuff(i,j,l)=data(i,j,ll,1)
        enddo
       enddo
!       write(*,*) Varname,' L ',l,': = ',data(1,1,ll,1)
     enddo
   endif

   deallocate(data)
   return

end subroutine getVariable
