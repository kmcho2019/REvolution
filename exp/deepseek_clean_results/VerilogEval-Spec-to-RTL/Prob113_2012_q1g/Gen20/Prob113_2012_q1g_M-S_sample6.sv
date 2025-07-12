module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ((~x[1] & ~x[0]) | (x[1] & ~x[0]))) |  // row00: 00 or 10
                (x[3] & x[2] & ~(x[1] & ~x[0])) |                       // row11: not 10
                (x[3] & ~x[2] & ~(x[1] & x[0]));                       // row10: not 11
endmodule