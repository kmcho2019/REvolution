module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire clk_delayed, clk_edge;
wire master_out, slave_out;
wire reset_clear;

// Clock edge detection (positive edge)
not #1 (clk_delayed, clk);
xor (clk_edge, clk, clk_delayed);

// Master stage
wire master_in = d & ~ar;
wire master_clk = clk_edge & ~ar;
and (master_gate, master_in, master_clk);
or (master_out, master_gate, slave_out & ~master_clk);

// Slave stage (output stage)
wire slave_clk = ~clk_edge & ~ar;
and (slave_gate, master_out, slave_clk);
or (slave_out, slave_gate, reset_clear);

// Asynchronous reset handling
assign reset_clear = ar;
assign q = slave_out & ~ar;

endmodule