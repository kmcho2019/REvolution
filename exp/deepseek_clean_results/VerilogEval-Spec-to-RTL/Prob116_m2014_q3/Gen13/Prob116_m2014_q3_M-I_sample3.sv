module TopModule(
    input [3:0] x,  // x[3] is MSB (x4 in K-map), x[0] is LSB (x1 in K-map)
    output f
);
    // Optimized implementation with alternative grouping
    assign f = (~x[3] & ~x[1] & x[0]) | (x[3] & ~x[2]) | (x[3] & x[1]);
endmodule