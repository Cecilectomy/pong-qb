'====================================================
'https://qb64phoenix.com/qb64wiki/index.php/Scancodes
'====================================================

DECLARE SUB MULTIKEYSTART ()
DECLARE SUB MULTIKEYSTOP ()

DECLARE SUB MULTIKEYUPDATE (T%)

DECLARE FUNCTION MULTIKEYPRESSED% (T%)
DECLARE FUNCTION MULTIKEYDOWN% (T%)
DECLARE FUNCTION MULTIKEYUP% (T%)

FUNCTION MULTIKEY% (T%)
    STATIC KBMatrix%(), Initialized

    IF NOT Initialized THEN
        DIM KBMatrix%(128)
        Initialized = -1
    END IF

    IF T% <= 0 THEN
        MULTIKEY = 0
        EXIT FUNCTION
    END IF

    i = INP(&H60)
    DO
        IF (i AND 128) THEN KBMatrix%(i XOR 128) = 0
        IF (i AND 128) = 0 THEN KBMatrix%(i) = -1
        i2 = i
        i = INP(&H60)
        POKE 1050, PEEK(1052)
    LOOP UNTIL i = i2

    MULTIKEY = KBMatrix%(T%)
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
