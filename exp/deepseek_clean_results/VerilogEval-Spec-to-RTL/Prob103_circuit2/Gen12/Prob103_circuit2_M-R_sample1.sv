module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // q = 1 when number of 1s in {a,b,c,d} is even (even parity)
    // Implemented as sum of minterms where q=1:
    // 0000, 0011, 0101, 0110, 1001, 1010, 1100, 1111
    assign q = (~a & ~b & ~c & ~d) |  // 0000
               (~a & ~b &  c &  d) |  // 0011
               (~a &  b & ~c &  d) |  // 0101
               (~a &  b &  c & ~d) |  // 0110
               ( a & ~b & ~c &  d) |  // 1001
               ( a & ~b &  c & ~d) |  // 1010
               ( a &  b & ~c & ~d) |  // 1100
               ( a &  b &  c &  d);   // 1111

endmodule