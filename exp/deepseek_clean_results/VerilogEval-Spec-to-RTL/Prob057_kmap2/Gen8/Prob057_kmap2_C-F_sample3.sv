module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining best of both solutions
assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00 (from Example 1)
    (!c & d & b) |       // cd=01, b=1 (simplified from Example 2)
    (c & !d & a) |       // cd=10, a=1 (simplified from Example 2)
    (a & b & !c & !d)    // cd=00, ab=11 (from Example 1)
);

endmodule