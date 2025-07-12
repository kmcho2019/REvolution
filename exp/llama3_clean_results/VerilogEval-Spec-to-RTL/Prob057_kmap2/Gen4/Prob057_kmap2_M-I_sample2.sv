module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~b) |         // a = 0, b = 0
             (~a & b & ~c) |     // a = 0, b = 1, c = 0
             (~a & b & d) |      // a = 0, b = 1, d = 1
             (a & b);            // a = 1, b = 1

endmodule