module TopModule (
    input clk,
    input d,
    output q
);

wire master_out;

// Master latch (active when clk is low)
assign master_out = ~clk ? d : master_out;

// Slave latch (active when clk is high)
assign q = clk ? master_out : q;

endmodule