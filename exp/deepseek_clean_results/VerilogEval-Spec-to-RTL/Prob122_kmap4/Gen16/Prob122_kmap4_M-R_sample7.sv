module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation using explicit minterms from K-map */
    wire term1 = ~a & ~b & ~c & d;  // 0001
    wire term2 = ~a & b & ~c & ~d;  // 0100
    wire term3 = ~a & b & c & d;    // 0111
    wire term4 = a & ~b & ~c & d;   // 1001
    wire term5 = a & ~b & c & ~d;   // 1010
    wire term6 = a & b & ~c & ~d;   // 1100
    wire term7 = a & b & c & d;     // 1111

    assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7;

endmodule