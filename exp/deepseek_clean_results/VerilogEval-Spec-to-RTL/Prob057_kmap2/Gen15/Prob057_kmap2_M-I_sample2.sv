module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Minimal SOP implementation from K-map analysis
assign out = (~a & ~b) |               // ab=00 covers cd=00,01,10
              (a & ~b & ~d) |          // ab=10, cd=00
              (b & ~c) |               // cd=11, ab=01 and cd=11, ab=11
              (a & ~c & (b | ~d));     // cd=11,ab=11 and cd=10,ab=11

endmodule