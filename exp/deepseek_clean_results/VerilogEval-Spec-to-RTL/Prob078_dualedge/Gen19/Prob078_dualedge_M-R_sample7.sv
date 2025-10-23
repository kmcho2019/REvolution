module TopModule (
    input clk,
    input d,
    output q
);

    wire q_pos, q_neg;
    wire clk_prev;
    
    // Store previous clock value for edge detection
    assign clk_prev = clk;
    
    // Positive edge triggered: when clk rises (0->1)
    assign q_pos = (clk && !clk_prev) ? d : q_pos;
    
    // Negative edge triggered: when clk falls (1->0)
    assign q_neg = (!clk && clk_prev) ? d : q_neg;
    
    // Output selection
    assign q = clk ? q_pos : q_neg;

endmodule