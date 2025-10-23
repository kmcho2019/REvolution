module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // The function implements the Karnaugh map:
    // bc\a | 0 | 1
    //  00  | 0 | 1
    //  01  | 1 | 1
    //  11  | 1 | 1
    //  10  | 1 | 1
    //
    // Simplified Boolean expression:
    // out = a + b + c
    // This is minimal and optimal for area, power, and timing.
    
    assign out = a | b | c;

endmodule