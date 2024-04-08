require pick-menu.fth
require colors.fth
require config.fth

: WILD-SPACE ( -- ) YELLOW ." WILD SPACE " FG-DEFAULT ;

variable game-state

: OPTIONS ( options count -- )  ;


: quit-game ." Thanks for playing!" CR ." (press any key to quit)" ekey drop bye ; 
: ->quit-game ['] quit-game game-state ! ;

\ Intro

: EK-WAIT ( -- ) ekey drop ;

VARIABLE why-risky-job-menu allot-pmenu

variable intro-choices 1 cells allot
0 VALUE intro-choices-idx
-1 VALUE why-this-risky-job 



: why-this-risky-job/show ( menu -- )
	." Why did you take up this risky job?" CR CR
	0 ?cursor ." To explore the stars and see wonders" CR
	1 ?cursor ." To escape a troubled past" CR
	2 ?cursor ." To amass a fortune" CR ;

: why-this-risky-job/act ( choice -- ) 
    TO why-this-risky-job 
    0 why-risky-job-menu >pmenu-focused ;

-1 why-risky-job-menu >pmenu-focused
0 why-risky-job-menu >pmenu-cursor
2 why-risky-job-menu >pmenu-count
' why-this-risky-job/show why-risky-job-menu >pmenu-show
' why-this-risky-job/act why-risky-job-menu >pmenu-act

: GAME-INTRO  ( -- )
  PAGE
  \ "      this is a width guideline              " 
  ." You're captain of a Plankton-class mini " CR
  ." freighter called KRILL It's not much, but " CR
  ." it can haul a respectable cargo load and " CR
  ." fend of against ion wasps and other pests"  CR CR

  why-risky-job-menu pmenu-do
  why-risky-job-menu pmenu-focused> 0= IF ->quit-game THEN
  BORDER-LIMITS
;
: ->game-intro ['] GAME-INTRO game-state ! ;


\ About


: ABOUT-GAME ( return-state -- )
    PAGE
  WILD-SPACE ." is a game by Andrew Owen" CR
  ." about the fantasy of goods arbitrage" CR
  ." as an excuse to explore in space" CR CR
  ." (press any key to return)" CR
  BORDER-LIMITS
        
    EKEY drop
;

\ Main Menu 

: SHOW-MAIN-MENU ( choice -- )
	PAGE
	." Welcome to " WILD-SPACE cr 
	0 ?cursor ." Start Game" CR
    1 ?cursor ." About " CR
	2 ?cursor ." Quit"  CR drop 
;

: ACT-MAIN-MENU ( choice -- ) 
case 
	0 of ->game-intro  endof
    1 of about-game endof
	2 of ->quit-game endof
	drop
endcase ekey drop ;

VARIABLE main-menu allot-pmenu
-1 main-menu >pmenu-focused
0 main-menu >pmenu-cursor
2 main-menu >pmenu-count
' SHOW-MAIN-MENU main-menu >pmenu-show
' ACT-MAIN-MENU main-menu >pmenu-act

: debug-main-menu ( ) 
  main-menu @ . main-menu pmenu-count> . ;

: GAME-START ( -- ) main-menu pmenu-do ;

\ Game loop

' GAME-START game-state !


: GAME BEGIN game-state @ EXECUTE BORDER-LIMITS AGAIN ;

GAME
