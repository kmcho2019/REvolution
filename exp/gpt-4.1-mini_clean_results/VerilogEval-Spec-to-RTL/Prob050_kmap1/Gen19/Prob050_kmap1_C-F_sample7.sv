// Optional structural module definitions for educational or hierarchical use.
// Uncomment to instantiate a purely structural TopModule instead of the minimal implementation.

/*
// Comparator1 outputs 1 if input is 1, else 0
module Comparator1 (
    input  in,
    output out
);
    assign out = in ? 1'b1 : 1'b0;
endmodule

// Or3Combiner performs a 3-input OR gate
module Or3Combiner (
    input  x,
    input  y,
    input  z,
    output out
);
    assign out = x | y | z;
endmodule

// Structural TopModule using Comparator1 and Or3Combiner
module TopModule_structural (
    input  a,
    input  b,
    input  c,
    output out
);
    wire a_valid, b_valid, c_valid;

    Comparator1 cmp_a (.in(a), .out(a_valid));
    Comparator1 cmp_b (.in(b), .out(b_valid));
    Comparator1 cmp_c (.in(c), .out(c_valid));

    Or3Combiner or_gate (.x(a_valid), .y(b_valid), .z(c_valid), .out(out));
endmodule
*/

// Minimal, optimal, and primary TopModule implementation:
// Implements Karnaugh map logic: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    assign out = a | b | c;
endmodule