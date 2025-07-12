module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified Boolean expression with 3 essential terms
assign out = ~(
    (a & b & c) |          // Covers ab=11, cd=11 and ab=11, cd=01
    (a & ~b & d) |         // Covers ab=10, cd=01 and ab=10, cd=11
    (~a & b & ~c & ~d)     // Covers ab=01, cd=00
);

endmodule