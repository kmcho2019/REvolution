module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out, slave_in;
wire clk_n = ~clk;

// Master latch (active when clk is low)
assign master_out = clk ? master_out : d;

// Slave latch (active when clk is high) with async reset
assign slave_in = clk ? master_out : slave_in;
assign q = ar ? 1'b0 : slave_in;

endmodule