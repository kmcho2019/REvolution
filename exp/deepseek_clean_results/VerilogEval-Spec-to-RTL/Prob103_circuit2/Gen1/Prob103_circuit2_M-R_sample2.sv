module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = (~a & ~b & ~c & ~d) |                     // All zeros
               (a & b & ~c & ~d) |                       // a and b
               (~a & b & c & ~d) |                       // b and c
               (~a & ~b & c & d) |                       // c and d
               (a & ~b & ~c & d) |                       // d and a
               (a & b & c & d);                          // All ones

endmodule