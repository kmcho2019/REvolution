/*
 * Latch-based D Flip-Flop with Active High Reset
 * 
 * Implements a DFF using master-slave latches with synchronous reset
 * 
 * Ports:
 *   clk - Clock input
 *   r   - Active high synchronous reset
 *   d   - Data input
 *   q   - Data output (registered)
 */
module TopModule(
    input  clk,
    input  r,
    input  d,
    output q
);

wire master_out;
wire slave_in;

// Master latch (transparent when clk is low)
assign master_out = (~clk) ? (r ? 1'b0 : d) : master_out;

// Slave latch (transparent when clk is high)
assign slave_in = r ? 1'b0 : master_out;
assign q = clk ? slave_in : q;

endmodule