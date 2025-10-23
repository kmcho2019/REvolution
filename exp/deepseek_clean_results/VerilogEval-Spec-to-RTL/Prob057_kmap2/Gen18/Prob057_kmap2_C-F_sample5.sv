module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Column (ab) pattern detectors (from Example 2)
wire ab00 = ~a & ~b;  // ab = 00
wire ab01 = ~a & b;   // ab = 01
wire ab11 = a & b;    // ab = 11
wire ab10 = a & ~b;   // ab = 10

// Optimized Boolean expression (from Example 1) using column patterns
assign out = ~(
    (ab00 & c & d) |      // cd=11, ab=00
    (ab11 & ~c) |         // Combined: cd=01,11 ab=11 and cd=00 ab=11
    (a & c & ~d) |        // Combined: cd=10 ab=11 and cd=10 ab=10
    (ab01 & ~c & d)       // cd=01 ab=01
);

endmodule