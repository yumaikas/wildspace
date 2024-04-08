require colors.fth
require config.fth

: ?cursor 
  over = if ." >" else ."  " then ;

: pmenu-cursor> @ ;
: >pmenu-cursor ! ;
: pmenu-count> ( c-addr -- limit ) 1 cells + @ ;
: >pmenu-count ( limit c-addr )    1 cells + ! ;
: >pmenu-show ( xt c-addr -- ) 2 cells + ! ;
: >pmenu-act ( xt pm-addr -- ) 3 cells + ! ;
: >pmenu-focused ( active? addr ) 4 cells + ! ;
: pmenu-focused> ( addr ) 4 cells + @ ;

: pmenu-show ( pm-addr -- ) { menu } menu @ menu 2 cells + @ EXECUTE ;
: pmenu-act ( pm-addr -- ) { menu } menu @ menu 3 cells + @ EXECUTE ;

: pmenu-cursor-wrap { inc menu } 
    menu @ inc + 0 max 
    menu pmenu-count> min menu ! ;

: allot-pmenu 4 cells allot ;
	
: pmenu-input ( menu-addr ) { menu }
  EKEY  ekey>char 
	IF ( is-char )
	  case 
	    13 of menu pmenu-act endof 
	  endcase
	ELSE
	 ekey>fkey if ( is-special-key )
	  case
       k-down of 
         1 menu pmenu-cursor-wrap 
       endof                
       k-up of 
         -1 menu pmenu-cursor-wrap 
       endof
      endcase 
	 drop ( key-event )
	 then 
	THEN
 ;
: BORDER-LIMITS ( -- )
 testing IF  
   28 0 DO 46 I at-xy ." #" LOOP
   0 28 at-xy
   46 0 DO ." #" LOOP
  THEN
;


: pmenu-do ( menu-addr ) { menu } 
	menu pmenu-focused> IF
		BRIGHT
		menu pmenu-show BORDER-LIMITS
		menu pmenu-input 
	ELSE DIM menu pmenu-show THEN
;
