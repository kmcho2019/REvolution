module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best aspects of both solutions
assign out = ~(
    (~a & ~b & c & d) |      // Essential term for cd=11, ab=00
    (a & b & (~c | ~d)) |    // Combined term for ab=11 cases
    (a & c & ~d) |           // Essential term for cd=10, ab=10
    (b & ~c & d)             // Essential term for cd=01, ab=01
);

endmodule