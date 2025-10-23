module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[0]) |        // 00x0
               (x[3] & x[2] & ~x[1]) |          // 11x0
               (x[3] & x[2] & x[1] & x[0]) |    // 1111
               (x[3] & ~x[2] & ~(x[1] & x[0])); // 10 and not 11
endmodule