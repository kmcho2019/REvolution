module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = (~a & ~b & ~c & ~d) |                 // 0000
               (~a & ~b & c & d) |                   // 0011
               (~a & b & ~c & d) |                  // 0101
               (~a & b & c & ~d) |                  // 0110
               (a & ~b & ~c & d) |                  // 1001
               (a & ~b & c & ~d) |                  // 1010
               (a & b & ~c & ~d) |                  // 1100
               (~a & b & c & d) |                   // 0111
               (a & ~b & c & d) |                   // 1011
               (a & b & ~c & d) |                   // 1101
               (a & b & c & ~d) |                   // 1110
               (a & b & c & d);                     // 1111
endmodule