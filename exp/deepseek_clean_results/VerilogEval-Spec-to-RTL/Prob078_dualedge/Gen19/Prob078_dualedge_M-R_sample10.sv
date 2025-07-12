module TopModule (
    input clk,
    input d,
    output q
);

    // Edge detection and storage using continuous assignments
    wire clk_prev;
    wire edge_detect = clk ^ clk_prev;
    
    // Storage elements implemented with feedback
    wire q_pos = edge_detect & clk ? d : q_pos;
    wire q_neg = edge_detect & ~clk ? d : q_neg;
    
    // Clock history tracking
    assign clk_prev = clk;
    
    // Output selection remains the same
    assign q = clk ? q_pos : q_neg;

endmodule