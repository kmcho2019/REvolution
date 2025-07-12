module TopModule (
    input clk,
    input d,
    output q
);

wire clk_n;      // Inverted clock
wire master_out; // Master latch output

// Inverted clock generation
assign clk_n = ~clk;

// Master latch (active when clock is high)
assign master_out = clk ? d : master_out;

// Slave latch (active when clock is low)
assign q = clk_n ? master_out : q;

endmodule