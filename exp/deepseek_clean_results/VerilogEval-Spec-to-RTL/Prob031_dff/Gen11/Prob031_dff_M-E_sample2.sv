module TopModule (
    input clk,
    input d,
    output reg q
);

reg master_latch;

// Master latch (transparent when clk is low)
always @(clk or d)
    if (!clk) master_latch <= d;

// Slave latch (transparent when clk is high)
always @(clk or master_latch)
    if (clk) q <= master_latch;

endmodule