module TopModule (
    input clk,
    input d,
    output q
);

reg posedge_reg;
reg negedge_reg;
wire pos_edge = clk && $past(!clk);  // Positive edge detection
wire neg_edge = !clk && $past(clk);  // Negative edge detection

// Update registers on respective edges
assign posedge_reg = pos_edge ? d : posedge_reg;
assign negedge_reg = neg_edge ? d : negedge_reg;

// Output selection remains the same but written differently
assign q = clk ? posedge_reg : negedge_reg;

endmodule