module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |       // 0000, 0010
               (x[3] & x[2] & ~x[1]) |        // 1100
               (x[3] & x[2] & x[1] & x[0]) |  // 1111
               (x[3] & ~x[2] & ~x[0]);        // 1000, 1010
endmodule