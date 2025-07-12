module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~b) |         // Combine cells with a = 0, b = 0
             (~a & b & ~c) |     // Combine cells with a = 0, b = 1, c = 0
             (~a & b & c & d) |  // Combine cells with a = 0, b = 1, c = 1, d = 1
             (a & b);            // Combine cells with a = 1, b = 1

endmodule