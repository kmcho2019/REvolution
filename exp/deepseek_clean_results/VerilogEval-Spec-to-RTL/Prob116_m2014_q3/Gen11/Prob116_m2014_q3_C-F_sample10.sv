module TopModule(
    input [3:0] x,  // x[3] = x[4], x[2] = x[3], x[1] = x[2], x[0] = x[1] in K-map
    output f
);
    // Optimized implementation combining clarity and compactness
    // term1 covers the top-right 1s and bottom-left 1s
    // term2 covers the middle-right 1 and bottom-center 1s
    assign f = (~x[0] & x[2]) | (x[0] & x[1] & x[3]);
endmodule