DECLARE
    n INT := &n;
    i INT;
    flag INT := 0;
BEGIN
    FOR i IN 2..n-1 LOOP
        IF MOD(n, i) = 0 THEN
            flag := 1;
            EXIT;
        END IF;
    END LOOP;

    IF flag = 0 AND n > 1 THEN
        DBMS_OUTPUT.PUT_LINE('Prime Number');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not a Prime Number');
    END IF;
END;
/