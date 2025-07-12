module TopModule(
    input [3:0] x,
    output f
);
    // Direct implementation of K-map patterns
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 00_00
               (~x[3] & ~x[2] & x[1] & ~x[0])  |  // 00_10
               (x[3] & x[2] & ~x[1] & ~x[0])  |   // 11_00
               (x[3] & x[2] & ~x[1] & x[0])  |    // 11_01
               (x[3] & x[2] & x[1] & x[0])  |     // 11_11
               (x[3] & ~x[2] & ~x[1] & ~x[0]) |   // 10_00
               (x[3] & ~x[2] & ~x[1] & x[0])  |   // 10_01
               (x[3] & ~x[2] & x[1] & ~x[0]);     // 10_10
endmodule