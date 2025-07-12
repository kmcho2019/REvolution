module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = (~a & ~b & ~c & ~d) |  // All zeros
               (a & b & c & d) |      // All ones
               (~a & ~b & c & d) |    // 0011
               (~a & b & ~c & d) |    // 0101
               (~a & b & c & ~d) |    // 0110
               (a & ~b & ~c & d) |    // 1001
               (a & ~b & c & ~d) |    // 1010
               (a & b & ~c & ~d);     // 1100
endmodule