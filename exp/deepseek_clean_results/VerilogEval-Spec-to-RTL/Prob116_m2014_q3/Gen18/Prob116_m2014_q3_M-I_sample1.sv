module TopModule(
    input [3:0] x,
    output f
);
    // Optimized implementation with better grouping
    // term1 covers all cases where x[3]=1 and x[1]=1
    // term2 covers the remaining '1's using x[2]
    assign f = (x[3] & x[1]) | (x[2] & ~x[0]);
endmodule