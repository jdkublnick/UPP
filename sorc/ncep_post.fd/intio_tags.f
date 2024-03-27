!> @file
!> @brief module: intio_tags_mod defines variables related to integer
!input/output
module intio_tags_mod
!
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       implicit none
!
  INTEGER, PARAMETER ::  int_ioexit			=  	     10
  INTEGER, PARAMETER ::  int_open_for_write_begin	=  	     20
  INTEGER, PARAMETER ::  int_open_for_write_commit	=  	     30
  INTEGER, PARAMETER ::  int_open_for_read 		=  	     40
  INTEGER, PARAMETER ::  int_intio_nextrec 		=  	     50
  INTEGER, PARAMETER ::  int_inquire_opened 		=  	     60
  INTEGER, PARAMETER ::  int_inquire_filename 		=  	     70
  INTEGER, PARAMETER ::  int_iosync 			=  	     80
  INTEGER, PARAMETER ::  int_ioclose 			=  	     90
  INTEGER, PARAMETER ::  int_next_time 			=  	    100
  INTEGER, PARAMETER ::  int_set_time 			=  	    110
  INTEGER, PARAMETER ::  int_next_var 			=  	    120
  INTEGER, PARAMETER ::  int_dom_ti_real 		=  	    140
  INTEGER, PARAMETER ::  int_dom_ti_double 		=  	    160
  INTEGER, PARAMETER ::  int_dom_ti_integer 		=  	    180
  INTEGER, PARAMETER ::  int_dom_ti_logical 		=  	    200
  INTEGER, PARAMETER ::  int_dom_ti_char 		=  	    220
  INTEGER, PARAMETER ::  int_dom_td_real 		=  	    240
  INTEGER, PARAMETER ::  int_dom_td_double 		=  	    260
  INTEGER, PARAMETER ::  int_dom_td_integer 		=  	    280
  INTEGER, PARAMETER ::  int_dom_td_logical 		=  	    300
  INTEGER, PARAMETER ::  int_dom_td_char 		=  	    320
  INTEGER, PARAMETER ::  int_var_ti_real 		=  	    340
  INTEGER, PARAMETER ::  int_var_ti_double 		=  	    360
  INTEGER, PARAMETER ::  int_var_ti_integer 		=  	    380
  INTEGER, PARAMETER ::  int_var_ti_logical 		=  	    400
  INTEGER, PARAMETER ::  int_var_ti_char 		=  	    420
  INTEGER, PARAMETER ::  int_var_td_real 		=  	    440
  INTEGER, PARAMETER ::  int_var_td_double 		=  	    460
  INTEGER, PARAMETER ::  int_var_td_integer 		=  	    480
  INTEGER, PARAMETER ::  int_var_td_logical 		=  	    500
  INTEGER, PARAMETER ::  int_var_td_char 		=  	    520
  INTEGER, PARAMETER ::  int_field 			=  	    530
  INTEGER, PARAMETER ::  int_var_info 			=  	    540
  INTEGER, PARAMETER ::  int_noop 			=  	    550

end module intio_tags_mod
