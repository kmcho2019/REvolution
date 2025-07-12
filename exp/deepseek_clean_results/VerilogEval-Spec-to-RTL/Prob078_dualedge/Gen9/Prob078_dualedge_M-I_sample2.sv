module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    
    // Positive edge capture
    always @(posedge clk) q_pos <= d;
    
    // Negative edge capture
    always @(negedge clk) q_neg <= d;
    
    // Optimized output selection
    assign q = clk ? q_pos : q_neg;

endmodule