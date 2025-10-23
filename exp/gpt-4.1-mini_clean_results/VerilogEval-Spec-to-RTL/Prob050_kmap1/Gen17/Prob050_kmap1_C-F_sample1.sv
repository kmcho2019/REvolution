// Optional gate-level module definitions for educational or structural use:
/*
module Inv (
    input  in,
    output out
);
    assign out = ~in;
endmodule

module And3 (
    input  x,
    input  y,
    input  z,
    output q
);
    assign q = x & y & z;
endmodule
*/

// TopModule implements the Karnaugh map logic: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Minimal and optimal implementation using continuous assignment
    assign out = a | b | c;
endmodule