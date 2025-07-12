module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |        // 0000, 0010
               (x[3] & ~x[2] & ~x[1]) |         // 1000, 1001
               (x[3] & x[2] & (~x[0] | x[1])) |  // 1100,1101,1110,1111
               (x[3] & ~x[2] & x[1] & x[0]);     // 1011
endmodule