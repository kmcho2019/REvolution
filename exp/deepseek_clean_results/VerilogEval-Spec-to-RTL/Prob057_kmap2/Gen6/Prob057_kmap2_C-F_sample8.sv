module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized boolean equation derived from K-map:
// Output is 0 in these cases:
// 1. cd=00 & ab=11
// 2. cd=01 & b=1
// 3. cd=10 & a=1
// 4. cd=11 & ab=00

assign out = ~(
    (~c & ~d & a & b) |  // Case 1
    (~c & d & b) |       // Case 2 (simplified)
    (c & ~d & a) |       // Case 3 (simplified)
    (c & d & ~a & ~b)    // Case 4
);

endmodule