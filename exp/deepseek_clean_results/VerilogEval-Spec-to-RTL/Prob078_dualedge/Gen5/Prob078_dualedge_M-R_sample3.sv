module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    wire clk_rise, clk_fall;
    
    // Detect clock edges
    assign clk_rise = clk && ~$past(clk);
    assign clk_fall = ~clk && $past(clk);
    
    // Positive edge capture
    assign q_pos = clk_rise ? d : q_pos;
    
    // Negative edge capture
    assign q_neg = clk_fall ? d : q_neg;
    
    // Output selection
    assign q = clk ? q_pos : q_neg;

endmodule