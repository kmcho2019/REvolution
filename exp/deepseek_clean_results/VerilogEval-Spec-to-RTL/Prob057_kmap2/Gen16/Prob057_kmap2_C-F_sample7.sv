module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized implementation combining best of both examples
assign out = (a & b & ~d) |  // Covers ab=11,cd=10 and ab=10,cd=11
             (~b & c) |      // Covers ab=00,cd=11 and ab=01,cd=11
             (~a & ~c & d) | // Covers ab=00,cd=01 and ab=10,cd=01
             (a & ~b & ~c); // Covers ab=10,cd=00 and ab=10,cd=10

endmodule