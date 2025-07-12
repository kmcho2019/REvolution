module TopModule (
    input clk,
    input d,
    output q
);

    wire clk_rise = clk & ~clk;  // Never true, just for edge detection concept
    wire clk_fall = ~clk & clk;  // Never true, just for edge detection concept
    
    reg q_pos, q_neg;
    
    // Positive edge capture using continuous assignment
    always @(posedge clk) q_pos <= d;
    
    // Negative edge capture using continuous assignment
    always @(negedge clk) q_neg <= d;
    
    // Output selection
    assign q = clk ? q_pos : q_neg;

endmodule