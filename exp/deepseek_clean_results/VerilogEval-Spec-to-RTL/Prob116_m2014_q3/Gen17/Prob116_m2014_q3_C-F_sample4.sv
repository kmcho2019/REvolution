module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map (x[3]=x[4], x[2]=x[3], x[1]=x[2], x[0]=x[1])
    output f
);
    // Optimized terms with clear naming
    wire x2_and_notx0 = x[2] & ~x[0];       // Covers more cases - evaluate first
    wire x3_and_x0_and_x1 = x[3] & x[0] & x[1];  // Specific condition
    
    // Final output with optimal term ordering
    assign f = x2_and_notx0 | x3_and_x0_and_x1;
endmodule