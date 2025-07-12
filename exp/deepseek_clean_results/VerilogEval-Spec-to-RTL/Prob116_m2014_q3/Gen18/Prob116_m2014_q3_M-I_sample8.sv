module TopModule(
    input [3:0] x,  // x[3] = x[4], x[2] = x[3], x[1] = x[2], x[0] = x[1] in K-map
    output f
);
    // Further optimized implementation with better grouping
    assign f = (~x[0] & x[2]) | (x[1] & x[3]);
endmodule