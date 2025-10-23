module TopModule (
    input clk,
    input d,
    output q
);

wire master_latch_out;

// Master latch (active when clk is low)
assign master_latch_out = ~clk ? d : master_latch_out;

// Slave latch (active when clk is high)
assign q = clk ? master_latch_out : q;

endmodule