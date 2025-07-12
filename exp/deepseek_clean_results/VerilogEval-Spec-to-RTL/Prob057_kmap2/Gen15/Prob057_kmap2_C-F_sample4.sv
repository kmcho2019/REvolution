module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Minimal SOP implementation from K-map analysis
assign out = (~a & ~b) |                     // Covers most 1s in first two rows
             (a & ~b & ~c) |                 // Covers ab=10, cd=00/01
             (~a & b & c & d) |              // Covers ab=01, cd=11
             (a & b & ~d) |                 // Covers ab=11, cd=11/10
             (~a & ~c & d);                  // Covers ab=01, cd=01

endmodule