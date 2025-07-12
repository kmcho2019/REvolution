module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~b) |         // a = 0, b = 0
             (~a & b & ~c) |     // a = 0, b = 1, c = 0
             (~a & b & c & d) |  // a = 0, b = 1, c = 1, d = 1
             (a & b & ~c) |      // a = 1, b = 1, c = 0
             (a & b & c & ~d) |  // a = 1, b = 1, c = 1, d = 0
             (a & b & c & d);    // a = 1, b = 1, c = 1, d = 1

endmodule