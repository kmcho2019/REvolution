module TopModule (
    input clk,
    input d,
    output q
);

    // Edge detection and storage
    wire clk_delayed;
    reg pos_ff, neg_ff;
    
    // Clock delay for edge detection
    assign clk_delayed = clk;
    
    // Positive edge capture (when clk rises and delayed is low)
    assign pos_ff = (clk & ~clk_delayed) ? d : pos_ff;
    
    // Negative edge capture (when clk falls and delayed is high)
    assign neg_ff = (~clk & clk_delayed) ? d : neg_ff;
    
    // Output selection (same as original)
    assign q = clk ? pos_ff : neg_ff;

endmodule