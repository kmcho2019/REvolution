module TopModule (
    input clk,
    input d,
    output q
);

wire master_out;
wire slave_out;

// Master latch (active when clk is low)
assign master_out = ~clk ? d : master_out;

// Slave latch (active when clk is high)
assign slave_out = clk ? master_out : slave_out;

// Final output
assign q = slave_out;

endmodule