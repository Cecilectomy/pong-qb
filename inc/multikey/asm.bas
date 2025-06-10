'==========================================================
'http://petesqbsite.com/sections/tutorials/tuts/FASTKEY.BAS
'==========================================================

DECLARE SUB MULTIKEYSTART ()
DECLARE SUB MULTIKEYSTOP ()

DECLARE SUB MULTIKEYUPDATE (T%)

DECLARE FUNCTION MULTIKEYPRESSED% (T%)
DECLARE FUNCTION MULTIKEYDOWN% (T%)
DECLARE FUNCTION MULTIKEYUP% (T%)

FUNCTION MULTIKEY% (T%)
    STATIC KBControl%(), KBMatrix%(), Initialized, StatusFlag

    IF NOT Initialized THEN
        DIM KBControl%(128)
        DIM KBMatrix%(128)

        code$ = ""
        code$ = code$ + "E91D00E93C00000000000000000000000000000000000000000000000000"
        code$ = code$ + "00001E31C08ED8BE24000E07BF1400FCA5A58CC38EC0BF2400B85600FAAB"
        code$ = code$ + "89D8ABFB1FCB1E31C08EC0BF2400BE14000E1FFCFAA5A5FB1FCBFB9C5053"
        code$ = code$ + "51521E560657E460B401A8807404B400247FD0E088C3B700B0002E031E12"
        code$ = code$ + "002E8E1E100086E08907E4610C82E661247FE661B020E6205F075E1F5A59"
        code$ = code$ + "5B589DCF"

        DEF SEG = VARSEG(KBControl%(0))

        FOR I% = 0 TO 155
            d% = VAL("&h" + MID$(code$, I% * 2 + 1, 2))
            POKE VARPTR(KBControl%(0)) + I%, d%
        NEXT I%

        I& = 16
        N& = VARSEG(KBMatrix%(0)): l& = N& AND 255: h& = ((N& AND &HFF00) \ 256): POKE I&, l&: POKE I& + 1, h&: I& = I& + 2
        N& = VARPTR(KBMatrix%(0)): l& = N& AND 255: h& = ((N& AND &HFF00) \ 256): POKE I&, l&: POKE I& + 1, h&: I& = I& + 2

        DEF SEG
        
        Initialized = -1
    END IF

    SELECT CASE T%
        CASE -1
            IF StatusFlag = 0 THEN
                DEF SEG = VARSEG(KBControl%(0))
                CALL ABSOLUTE(0)
                DEF SEG

                StatusFlag = 1
            END IF
        CASE -2
            IF StatusFlag = 1 THEN
                DEF SEG = VARSEG(KBControl%(0))
                CALL ABSOLUTE(3)
                DEF SEG
                
                StatusFlag = 0
            END IF
        CASE 1 TO 128
            MULTIKEY = KBMatrix%(T%)
        CASE ELSE
            MULTIKEY = 0
    END SELECT
END FUNCTION

SUB MULTIKEYSTART
    Z = MULTIKEY(-1)
END SUB

SUB MULTIKEYSTOP
    Z = MULTIKEY(-2)
END SUB

FUNCTION MULTIKEYCHECK% (M%, T%)
    STATIC KBLastMatrix%(), Initialized

    IF NOT Initialized THEN
        DIM KBLastMatrix%(128)
        Initialized = -1
    END IF

	k% = MULTIKEY(T%)
    MULTIKEYCHECK% = 0

    SELECT CASE M%
        CASE 0: KBLastMatrix%(T%) = k%
        CASE 1: MULTIKEYCHECK% = k%
        CASE 2: IF k% AND NOT KBLastMatrix%(T%) THEN: MULTIKEYCHECK% = -1
        CASE 3: IF NOT k% AND KBLastMatrix%(T%) THEN: MULTIKEYCHECK% = -1
    END SELECT
END FUNCTION

SUB MULTIKEYUPDATE (T%)
    Z = MULTIKEYCHECK(0, T%)
END SUB

FUNCTION MULTIKEYPRESSED% (T%)
    MULTIKEYPRESSED% = MULTIKEYCHECK(1, T%)
END FUNCTION

FUNCTION MULTIKEYDOWN% (T%)
    MULTIKEYDOWN% = MULTIKEYCHECK(2, T%)
END FUNCTION

FUNCTION MULTIKEYUP% (T%)
    MULTIKEYUP% = MULTIKEYCHECK(3, T%)
END FUNCTION
