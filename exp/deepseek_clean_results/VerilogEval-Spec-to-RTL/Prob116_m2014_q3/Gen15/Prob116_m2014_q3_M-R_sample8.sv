module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // Intermediate signals for clearer logic breakdown
    wire case1 = ~x[0] & x[2];        // First condition from K-map
    wire case2 = x[0] & x[1] & x[3];  // Second condition from K-map
    
    // Final output combining both cases
    assign f = case1 | case2;
endmodule