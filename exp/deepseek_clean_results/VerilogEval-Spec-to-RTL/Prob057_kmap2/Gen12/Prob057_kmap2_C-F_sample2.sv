module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized fusion of both examples
assign out = ~(
    (~a & ~b & c & d) |  // Essential for cd=11,ab=00
    (b & ~c & d) |       // Covers two cd=01 cases
    (a & c & ~d) |       // Covers two cd=10 cases
    (a & b & ~c & ~d)    // Essential for cd=00,ab=11
);

endmodule