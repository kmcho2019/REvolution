module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ((~x[1] & ~x[0]) | (x[1] & ~x[0]))) |  // 00: 0000 or 0010
               (x[3] & x[2] & ~(x[1] & ~x[0])) |                       // 11: all except 1110
               (x[3] & ~x[2] & ~(x[1] & x[0]));                       // 10: all except 1011
endmodule