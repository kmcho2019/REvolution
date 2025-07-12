module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Hierarchical decision tree implementation
    assign f = x[3] ? 
               (x[2] ? 
                1'b1 :  // Top-right quadrant (11xx) - mostly 1's
                (x[1] & x[0]) ? 1'b1 : 1'b0) :  // 10xx cases
               (x[2] ? 
                (x[0] ? 1'b1 : 1'b0) :  // 01xx cases
                1'b0);  // 00xx cases (mostly 0's)
endmodule