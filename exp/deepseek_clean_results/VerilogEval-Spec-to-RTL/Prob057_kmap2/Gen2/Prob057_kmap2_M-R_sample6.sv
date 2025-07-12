module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a & ~b & ~(c & d)) |  // covers ab=00 except cd=11
                 (~a & b & c) |           // covers ab=01, cd=11 and ab=11, cd=01
                 (a & ~b & ~c) |          // covers ab=10, cd=00
                 (a & b & ~d) |           // covers ab=11, cd=10
                 (a & ~b & d);            // covers ab=10, cd=01 and ab=01, cd=00
endmodule