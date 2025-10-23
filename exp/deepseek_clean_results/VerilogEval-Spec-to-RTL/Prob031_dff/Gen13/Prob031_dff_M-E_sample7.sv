module TopModule (
    input clk,
    input d,
    output q
);

wire master_out, slave_out;
wire clk_n = ~clk;

// Master latch (transparent when clk is low)
assign master_out = (clk_n & d) | (~clk_n & master_out);

// Slave latch (transparent when clk is high)
assign slave_out = (clk & master_out) | (~clk & slave_out);

assign q = slave_out;

endmodule