module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression combining the best of both solutions
assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00 (precise from Example 1)
    (!c & d & b) |       // cd=01 (simplified from Example 2)
    (a & b & !c & !d) |  // cd=00, ab=11 (precise from Example 1)
    (a & c & !d)         // cd=10 (simplified to cover both ab cases)
);

endmodule