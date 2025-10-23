module TopModule (
    input clk,
    input d,
    output q
);

reg pos_edge_ff, neg_edge_ff;
wire clk_posedge = clk & ~$past(clk);
wire clk_negedge = ~clk & $past(clk);

// Positive edge triggered using assign
assign pos_edge_ff = clk_posedge ? d : pos_edge_ff;

// Negative edge triggered using assign
assign neg_edge_ff = clk_negedge ? d : neg_edge_ff;

// Output selection
assign q = clk ? pos_edge_ff : neg_edge_ff;

endmodule