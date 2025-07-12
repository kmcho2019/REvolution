module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Sum-of-products implementation of even parity checker
    assign q = (~a & ~b & ~c & ~d) |  // All zeros
               (~a & ~b & c & d) |    // c and d high
               (~a & b & ~c & d) |    // b and d high
               (~a & b & c & ~d) |    // b and c high
               (a & ~b & ~c & d) |    // a and d high
               (a & ~b & c & ~d) |    // a and c high
               (a & b & ~c & ~d) |    // a and b high
               (a & b & c & d);       // All ones

endmodule