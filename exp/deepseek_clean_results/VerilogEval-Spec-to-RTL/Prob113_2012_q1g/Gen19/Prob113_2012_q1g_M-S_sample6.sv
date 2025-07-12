module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (~x[0] | ~x[1])) |  // Row 00: 00 or 10
               (x[3] & x[2] & (x[0] | ~x[1])) |     // Row 11: not 10
               (x[3] & ~x[2] & ~x[1]);              // Row 10: 00 or 10
endmodule