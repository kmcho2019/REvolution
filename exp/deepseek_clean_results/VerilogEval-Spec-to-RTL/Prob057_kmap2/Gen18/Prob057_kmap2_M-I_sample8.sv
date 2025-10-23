module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Minimal SOP implementation from K-map
assign out = (~a & ~b) |                     // ab=00 covers cd=00,01,10
              (a & ~b & ~d) |                 // ab=10, cd=00
              (a & b & ~c) |                  // ab=11, cd=01
              (a & b & c) |                   // ab=11, cd=11
              (~a & b & ~c) |                 // ab=01, cd=11
              (a & ~b & c);                   // ab=10, cd=11

endmodule