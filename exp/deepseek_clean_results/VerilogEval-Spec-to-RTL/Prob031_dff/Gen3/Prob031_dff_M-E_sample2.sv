module TopModule (
    input clk,
    input d,
    output q
);

wire master_latch_out;

// Master latch (negative level-sensitive)
assign master_latch_out = ~clk ? d : master_latch_out;

// Slave latch (positive level-sensitive)
assign q = clk ? master_latch_out : q;

endmodule