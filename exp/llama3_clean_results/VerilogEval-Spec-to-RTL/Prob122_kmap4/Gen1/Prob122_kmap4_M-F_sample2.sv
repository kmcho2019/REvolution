module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = 
    // When c = 0, d = 0, and ab = 01
    (c == 0 && d == 0 && a == 0 && b == 1) ||
    
    // When c = 0, d = 1, and ab = 00 or 11
    (c == 0 && d == 1 && ((a == 0 && b == 0) || (a == 1 && b == 1))) ||
    
    // When c = 1, d = 0, and ab = 00 or 11
    (c == 1 && d == 0 && ((a == 0 && b == 0) || (a == 1 && b == 1))) ||
    
    // When c = 1, d = 1, and ab = 01 or 10
    (c == 1 && d == 1 && ((a == 0 && b == 1) || (a == 1 && b == 0)));

endmodule