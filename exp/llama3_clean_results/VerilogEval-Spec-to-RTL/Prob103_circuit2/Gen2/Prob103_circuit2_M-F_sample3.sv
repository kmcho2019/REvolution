module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (~a & ~b & ~c & ~d) |  // All inputs are 0
           (a & ~b & c & ~d) |  // a and c are 1
           (~a & b & ~c & d) |  // b and d are 1
           (~a & ~b & c & d) |  // c and d are 1
           (~a & b & c & ~d) |  // b and c are 1
           (a & ~b & ~c & d) |  // a and d are 1
           (a & b & c & d);     // All inputs are 1

endmodule