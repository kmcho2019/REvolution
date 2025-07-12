module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out, slave_out;
wire clk_gated = clk & ~ar;  // Gate clock during reset

// Master latch (negative level-sensitive)
always @(clk_gated or ar or d)
    if (ar) master_out <= 1'b0;
    else if (!clk_gated) master_out <= d;

// Slave latch (positive level-sensitive)
always @(clk_gated or ar or master_out)
    if (ar) slave_out <= 1'b0;
    else if (clk_gated) slave_out <= master_out;

assign q = slave_out;

endmodule