module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1]) |          // 00x0 cases
               (x[3] & x[2] & ~(x[1] & x[0])) |    // 11xx except 1111
               (x[3] & ~x[2] & ~(x[1] & x[0]));    // 10xx except 1011
endmodule