module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = 
    // For ab = 00, cd = 00
    (~a & ~b & ~c & ~d) |
    // For ab = 01, cd = 00
    (a & ~b & ~c & ~d) |
    // For ab = 00, cd = 01
    (~a & ~b & c & ~d) |
    // For ab = 00, cd = 10
    (~a & ~b & ~c & d) |
    // For ab = 01, cd = 10
    (a & ~b & ~c & d) |
    // For ab = 11, cd = 01
    (a & b & c & ~d) |
    // For ab = 11, cd = 11
    (a & b & c & d) |
    // For ab = 10, cd = 00
    (~a & b & ~c & ~d) |
    // For ab = 10, cd = 01
    (~a & b & c & ~d);

endmodule