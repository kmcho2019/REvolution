module TopModule (
    input clk,
    input d,
    output q
);

wire clk_n;       // Inverted clock
wire master_out;  // Master latch output
wire slave_out;   // Slave latch output

// Invert the clock for master latch
assign clk_n = ~clk;

// Master latch (active when clock is low)
assign master_out = clk_n ? d : master_out;

// Slave latch (active when clock is high)
assign slave_out = clk ? master_out : slave_out;

// Final output
assign q = slave_out;

endmodule