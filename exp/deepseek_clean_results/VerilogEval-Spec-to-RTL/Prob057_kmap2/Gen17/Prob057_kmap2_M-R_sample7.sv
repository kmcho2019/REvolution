module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b) |               // ab=00 covers cd=00,01,10
             (~a & b & ~c & ~d) |      // ab=01, cd=00
             (~a & b & c & d) |        // ab=01, cd=11
             (a & ~b & ~c & ~d) |      // ab=10, cd=00
             (a & ~b & ~c & d) |       // ab=10, cd=01
             (a & b & ~c & ~d) |       // ab=11, cd=00
             (a & b & c & d) |         // ab=11, cd=11
             (a & b & c & ~d);         // ab=11, cd=10

endmodule