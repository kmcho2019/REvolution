module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 0000
               (~x[3] & ~x[2] & x[1] & ~x[0]) |   // 0010
               (x[3] & ~x[1] & ~x[0]) |          // 1x00
               (x[3] & x[2] & ~x[1]) |           // 110x
               (x[3] & ~x[2] & x[1] & ~x[0]);    // 1010
endmodule