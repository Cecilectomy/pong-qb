'$INCLUDE:'inc\multikey\multikey.bi'

DECLARE SUB INTROSPLASH ()
DECLARE SUB MAINMENU ()
DECLARE SUB OPTIONSMENU ()
DECLARE SUB GAMELOOP ()
DECLARE SUB SHOWWINNER ()
DECLARE SUB PLAYCREDITS ()
DECLARE SUB GAMEOVER ()

DECLARE SUB SETSTATE (newstate%)

CONST STATEINTRO = 0
CONST STATEMENU = 1
CONST STATEOPTIONS = 2
CONST STATEPLAY = 3
CONST STATEWINNER = 4
CONST STATECREDITS = 5
CONST STATEGAMEOVER = 6
CONST STATEEXIT = -1

DIM SHARED state%: state% = STATEINTRO
DIM SHARED stateprev%: stateprev% = state%
DIM SHARED statechanged%: statechanged% = 0

DIM SHARED beep$: beep$ = ""
DIM SHARED winner$: winner$ = ""

DIM SHARED difficulty%: difficulty% = 1
DIM SHARED scorelimit%: scorelimit% = 11

DIM SHARED scorecolor%: scorecolor% = 15
DIM SHARED netcolor%: netcolor% = 15
DIM SHARED paddlecolor%: paddlecolor% = 15

version$ = "Version 1.0.0"

RANDOMIZE TIMER
SCREEN 7, 0, 1, 0

MULTIKEYSTART

DO UNTIL state% = STATEEXIT
	_LIMIT(60)

	PCOPY 1, 0
	_DISPLAY
	CLS

	SELECT CASE state%
		CASE STATEINTRO: INTROSPLASH
		CASE STATEMENU: MAINMENU
		CASE STATEOPTIONS: OPTIONSMENU
		CASE STATEPLAY: GAMELOOP
		CASE STATEWINNER: SHOWWINNER
		CASE STATECREDITS: PLAYCREDITS
		CASE STATEGAMEOVER: GAMEOVER
	END SELECT

	statechanged% = 0
	IF state% <> stateprev% THEN stateprev% = state%: statechanged% = -1

	MULTIKEYUPDATE(1)
	MULTIKEYUPDATE(28)
	MULTIKEYUPDATE(72)
	MULTIKEYUPDATE(75)
	MULTIKEYUPDATE(77)
	MULTIKEYUPDATE(80)
LOOP

MULTIKEYSTOP

SYSTEM

SUB SETSTATE (newstate%)
	SHARED state%, stateprev%

	stateprev% = state%
	state% = newstate%
END SUB

SUB INTROSPLASH
	STATIC StartTime, Initialized

	SHARED statechanged%

	IF NOT Initialized OR statechanged% THEN
		StartTime = TIMER

		Initialized = -1
	END IF

	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEMENU): EXIT SUB
	IF MULTIKEYDOWN(28) THEN SETSTATE(STATEMENU): EXIT SUB

	IF TIMER - StartTime > 2 THEN SETSTATE(STATEMENU)

	COLOR 4: LOCATE 12, 15: PRINT "CECILECTOMY";
	COLOR 15: LOCATE 14, 16: PRINT "presents";
END SUB

SUB MAINMENU
	STATIC x%, y%, lx%, ly%, Initialized

	SHARED statechanged%, version$

	IF NOT Initialized OR statechanged% THEN
		x% = 10: lx% = x%
		y% = 16: ly% = y%

		Initialized = -1
	END IF
	
	FOR box = 0 TO 3
		LINE (113, 67 + box * 16)-(207, 83 + box * 16), 8, B
	NEXT

	COLOR 8: LOCATE 24, 2: PRINT version$;

	COLOR INT(RND * 15) + 1: LOCATE 6, 19: PRINT "P";
	COLOR INT(RND * 15) + 1: LOCATE 6, 20: PRINT "O";
	COLOR INT(RND * 15) + 1: LOCATE 6, 21: PRINT "N";
	COLOR INT(RND * 15) + 1: LOCATE 6, 22: PRINT "G";

	COLOR 15: LOCATE 10, 18: PRINT "START";
	COLOR 15: LOCATE 12, 18: PRINT "OPTIONS";
	COLOR 15: LOCATE 14, 18: PRINT "CREDITS";
	COLOR 15: LOCATE 16, 18: PRINT "QUIT";

	LOCATE lx%, ly%: PRINT " ";
	COLOR 4: LOCATE x%, y%: PRINT "*";

	lx% = x%
	ly% = y%
	
	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEGAMEOVER): EXIT SUB

	IF MULTIKEYDOWN(80) THEN x% = x% + 2
	IF MULTIKEYDOWN(72) THEN x% = x% - 2

	IF x% > 16 THEN x% = 10
	IF x% < 10 THEN x% = 16

	IF MULTIKEYDOWN(28) THEN
		SELECT CASE x%
			CASE 10: SETSTATE(STATEPLAY)
			CASE 12: SETSTATE(STATEOPTIONS)
			CASE 14: SETSTATE(STATECREDITS)
			CASE 16: SETSTATE(STATEGAMEOVER)
		END SELECT
	END IF
END SUB

SUB OPTIONSMENU
	STATIC side%, x%, y%, lx%, ly%, Initialized

	SHARED statechanged%, beep$, difficulty%, scorelimit%, scorecolor%, netcolor%, paddlecolor%

	IF NOT Initialized OR statechanged% THEN
		side% = 1

		x% = 6: lx% = x%
		y% = 3: ly% = y%

		Initialized = -1
	END IF

	FOR box = 0 TO 5
		LINE (8, 35 + box * 16)-(156, 35 + 16 + box * 16), 8, B
		LINE (164, 35 + box * 16)-(311, 35 + 16 + box * 16), 8, B
		
		SELECT CASE box
			CASE 1: PAINT (166, 35 + box * 16 + 2), scorecolor%, 8
			CASE 3: PAINT (166, 35 + box * 16 + 2), netcolor%, 8
			CASE 5: PAINT (166, 35 + box * 16 + 2), paddlecolor%, 8
		END SELECT
	NEXT

	COLOR  8: LOCATE 24,  2: PRINT version$;
	
	COLOR 15: LOCATE  2, 17: PRINT "OPTIONS";

	COLOR 15: LOCATE  6,  5: PRINT "COMPUTER";
	COLOR 15: LOCATE 10,  5: PRINT "SOUND";
	COLOR 15: LOCATE 14,  5: PRINT "SCORE LIMIT";

	COLOR 15: LOCATE  6, 25: PRINT "SCORE COLOR";
	COLOR 15: LOCATE 10, 25: PRINT "NET COLOR";
	COLOR 15: LOCATE 14, 25: PRINT "PADDLE COLOR";

	COLOR 15: LOCATE 20, 19: PRINT "DONE";
	
	COLOR 7: LOCATE 8, 5: 
	SELECT CASE difficulty%
		CASE 1: PRINT "EASY";
		CASE 2: PRINT "HARD";
		CASE 3: PRINT "IMPOSSIBLE";
	END SELECT

	COLOR 7: LOCATE 12, 5: IF LEN(beep$) > 0 THEN PRINT "ON" ELSE PRINT "OFF";
	COLOR 7: LOCATE 16, 5: PRINT LTRIM$(RTRIM$(STR$(scorelimit%)));

	LOCATE lx%, ly%: PRINT " ";
	COLOR 4: LOCATE x%, y%: PRINT "*";

	lx% = x%
	ly% = y%
	
	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEMENU): EXIT SUB
		
	IF MULTIKEYDOWN(75) AND x% <> 20 THEN side% = 1
	IF MULTIKEYDOWN(77) AND x% <> 20 THEN side% = 2

	IF side% = 1 THEN y% = 3
	IF side% = 2 THEN y% = 22

	IF MULTIKEYDOWN(80) THEN x% = x% + 4

	IF MULTIKEYDOWN(72) THEN
		IF x% > 14 THEN x% = 14 ELSE x% = x% - 4
	END IF

	IF x% < 6 THEN x% = 20
	IF x% > 20 THEN x% = 6
	IF x% > 14 THEN x% = 20: y% = 17

	IF MULTIKEYDOWN(28) THEN
		SELECT CASE x%
			CASE 6
				IF side% = 1 THEN GOSUB difficultyselect
				IF side% = 2 THEN GOSUB scorecolor
			CASE 10
				IF side% = 1 THEN GOSUB soundtoggle
				IF side% = 2 THEN GOSUB netcolor
			CASE 14
				IF side% = 1 THEN GOSUB scorelimit
				IF side% = 2 THEN GOSUB paddlecolor
			CASE 20
				SETSTATE(STATEMENU)
		END SELECT
	END IF

	EXIT SUB

	difficultyselect:
		LOCATE 8, 3: PRINT SPACE$(14);
		difficulty% = difficulty% + 1
		IF difficulty% > 3 THEN difficulty% = 1
	RETURN

	soundtoggle:
		LOCATE 12, 3: PRINT SPACE$(14);
		IF LEN(beep$) > 0 THEN beep$ = "" ELSE beep$ = "MB L8 A"
	RETURN

	scorelimit:
		LOCATE 16, 3: PRINT SPACE$(14);
		scorelimit% = scorelimit% + 1
		IF scorelimit% > 21 THEN scorelimit% = 1
	RETURN

	scorecolor:
		scorecolor% = scorecolor% + 1
		IF scorecolor% > 15 THEN scorecolor% = 1
	RETURN

	netcolor:
		netcolor% = netcolor% + 1
		IF netcolor% > 15 THEN netcolor% = 1
	RETURN

	paddlecolor:
		paddlecolor% = paddlecolor% + 1
		IF paddlecolor% > 15 THEN paddlecolor% = 1
	RETURN
END SUB

SUB GAMELOOP
	STATIC score%, score2%
	STATIC paddlex%, paddley%, paddlenewy%
	STATIC paddle2x%, paddle2y%, paddle2newy%, comp%, sety%, overshoot%
	STATIC ballx%, bally%, horizballdir%, vertballdir%
	STATIC Initialized

	SHARED statechanged%, winner$, beep$

	IF NOT Initialized OR statechanged% THEN
		score% = 0
		score2% = 0

		paddlex% = 20
		paddley% = 100
		paddlenewy% = paddley%

		paddle2x% = 300 - 3
		paddle2y% = 100
		paddle2newy% = paddle2y%

		comp% = 0
		sety% = 0
		overshoot% = 0

		ballx% = 160
		bally% = 100

		horizballdir% = 1
		vertballdir% = 1

		Initialized = -1
	END IF

	score$ = LTRIM$(RTRIM$(STR$(score%)))
	score2$ = LTRIM$(RTRIM$(STR$(score2%)))

	COLOR scorecolor%
	LOCATE 2, 2: PRINT score$;
	LOCATE 2, 40 - LEN(score2$): PRINT score2$;

	FOR net = 0 TO 24
		LINE (160, 2 + net * 8)-(160, 6 + net * 8), netcolor%
	NEXT

	LINE (ballx%-1, bally%-1)-(ballx%+1, bally%+1), 15, BF

	LINE (paddlex%, paddley% - 10)-(paddlex% + 2, paddley% + 10), paddlecolor%, BF
	LINE (paddle2x%, paddle2y% - 10)-(paddle2x% + 2, paddle2y% + 10), paddlecolor%, BF

	IF bally% >= 200 THEN vertballdir% = 2
	IF bally% <= 0 THEN vertballdir% = 1

	IF horizballdir% = 1 THEN ballx% = ballx% + 3
	IF horizballdir% = 2 THEN ballx% = ballx% - 3
	IF vertballdir% = 1 THEN bally% = bally% + 3
	IF vertballdir% = 2 THEN bally% = bally% - 3

	IF ballx% >= 320 THEN
		ballx% = 1
		score% = score% + 1
	END IF

	IF ballx% <= 0 THEN
		ballx% = 319
		score2% = score2% + 1
	END IF
	
	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEMENU): EXIT SUB

	IF MULTIKEYPRESSED(72) THEN paddlenewy% = paddlenewy% - 5
	IF MULTIKEYPRESSED(80) THEN paddlenewy% = paddlenewy% + 5
	
	IF paddlenewy% <= 0 THEN paddlenewy% = 0
	IF paddlenewy% >= 200 THEN paddlenewy% = 200

    paddley% = paddley% + ((paddlenewy% - paddley%) * 0.15)
	
	IF difficulty% = 1 THEN GOSUB computer1
	IF difficulty% = 2 THEN GOSUB computer2
	IF difficulty% = 3 THEN GOSUB computer3

	IF ballx% > 160 AND paddle2newy% < (comp% + overshoot%) AND paddle2newy% <= 200 THEN paddle2newy% = paddle2newy% + 3
	IF ballx% > 160 AND paddle2newy% > (comp% + overshoot%) AND paddle2newy% >= 0 THEN paddle2newy% = paddle2newy% - 3

    paddle2y% = paddle2y% + ((paddle2newy% - paddle2y%) * 0.15)

	IF bally% >= paddley% - 10 AND bally% <= (paddley% + 10) AND ballx% >= paddlex% AND ballx% <= paddlex% + 3 THEN
		horizballdir% = 1
		PLAY beep$
	END IF

	IF bally% >= paddle2y% - 10 AND bally% <= (paddle2y% + 10) AND ballx% >= paddle2x% AND ballx% <= paddle2x% + 3 THEN
		horizballdir% = 2
		PLAY beep$
	END IF

	IF horizballdir% = 1 THEN GOSUB calculate
	
	IF score% = scorelimit% OR score2% = scorelimit% THEN
		IF score% = scorelimit% THEN winner$ = "PLAYER"
		IF score2% = scorelimit% THEN winner$ = "COMPUTER"

		SETSTATE(STATEWINNER)
	END IF

	EXIT SUB

	calculate:
		IF vertballdir% = 1 THEN comp% = 200 - (297 - ((200 - bally%) + ballx%))
		IF vertballdir% = 2 THEN comp% = 297 - (ballx% + bally%)

		IF comp% > 200 AND vertballdir% = 1 THEN
			comp% = comp% - 200
			comp% = 200 - comp%
		END IF

		IF comp% < 0 THEN comp% = ABS(comp%)
	RETURN

	computer1:
		IF ballx% <= 160 THEN overshoot% = INT(RND * 30) - 15
	RETURN

	computer2:
		IF ballx% <= 160 THEN overshoot% = INT(RND * 20) - 10
		
		IF horizballdir% = 2 AND ballx% >= 160 THEN sety% = INT(RND * 150) + 25
		
		IF ballx% < 160 AND paddle2newy% < sety% AND paddle2newy% <= 200 THEN paddle2newy% = paddle2newy% + 3
		IF ballx% < 160 AND paddle2newy% > sety% AND paddle2newy% >= 0 THEN paddle2newy% = paddle2newy% - 3
	RETURN

	computer3:
		overshoot% = 0

		IF ballx% < 160 AND paddle2newy% < 100 THEN paddle2newy% = paddle2newy% + 3
		IF ballx% < 160 AND paddle2newy% > 100 THEN paddle2newy% = paddle2newy% - 3
	RETURN
END SUB

SUB SHOWWINNER
	STATIC ShowWinnerStart, Initialized

	SHARED statechanged%, winner$

	IF NOT Initialized OR statechanged% THEN
		ShowWinnerStart = TIMER

		Initialized = -1
	END IF

	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEMENU): EXIT SUB
	IF MULTIKEYDOWN(28) THEN SETSTATE(STATEMENU): EXIT SUB

	IF TIMER - ShowWinnerStart > 2.5 THEN SETSTATE(STATEMENU)

	message$ = UCASE$(winner$) + " WINS"
	LOCATE 13, 20 - (LEN(message$) / 2): PRINT message$;
END SUB

SUB PLAYCREDITS
	STATIC a%, b%, c%, credits$(), StartTime, Initialized

	SHARED statechanged%

	IF NOT Initialized OR statechanged% THEN
		REDIM credits$(3)

		credits$(0) = "Programmed by Daniel Cecil in QuickBASIC"
		credits$(1) = "Special thanks to Tim Harrison          Daniel Zorub & Sammy Whitton"
		credits$(2) = "A CECILECTOMY Game"

		a% = 0
		b% = 0
		c% = 0

		StartTime = TIMER

		Initialized = -1
	END IF

	IF TIMER - StartTime > 0.15 THEN
		StartTime = TIMER
		b% = b% + 1
	END IF

	IF b% > 24 THEN
		b% = 0
		a% = a% + 1
		c% = 0
	END IF

	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEMENU): EXIT SUB
	IF MULTIKEYDOWN(28) THEN SETSTATE(STATEMENU): EXIT SUB
	
	IF a% > UBOUND(credits$) - 1 THEN SETSTATE(STATEMENU): EXIT SUB
	
	credit$ = credits$(a%)

	IF b% = 24 OR b% = 1 THEN c% = 0
	IF b% = 23 OR b% = 2 THEN c% = 8
	IF b% = 22 OR b% = 3 THEN c% = 7
	IF b% = 21 OR b% = 4 THEN c% = 15

	COLOR c%: LOCATE 25 - b%, 1: PRINT credit$;
END SUB

SUB GAMEOVER
	STATIC a%, c%, GameOverStart, Initialized
	SHARED statechanged%

	IF NOT Initialized OR statechanged% THEN
		a% = 0
		c% = 0

		GameOverStart = TIMER

		Initialized = -1
	END IF

	IF TIMER - GameOverStart > 0.1 THEN
		GameOverStart = TIMER
		a% = a% + 1
	END IF

	IF MULTIKEYDOWN(1) THEN SETSTATE(STATEEXIT): EXIT SUB
	IF MULTIKEYDOWN(28) THEN SETSTATE(STATEEXIT): EXIT SUB

	IF a% > 30 THEN SETSTATE(STATEEXIT): EXIT SUB

	IF a% = 1 OR a% = 29 THEN c% = 15
	IF a% = 3 OR a% = 27 THEN c% = 14
	IF a% = 5 OR a% = 25 THEN c% = 6
	IF a% = 7 OR a% = 23 THEN c% = 4

	COLOR c%: LOCATE 13, 16: PRINT "GAME OVER";
END SUB
