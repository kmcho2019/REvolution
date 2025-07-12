module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire master_latch_out;
wire slave_latch_out;
wire reset_pulse;
wire clk_inv;
wire d_muxed;

// Asynchronous reset pulse generation
assign reset_pulse = ar;

// Clock inversion for master-slave separation
assign clk_inv = ~clk;

// Reset mux - async reset has priority
assign d_muxed = reset_pulse ? 1'b0 : d;

// Master latch (negative level-sensitive)
DLatch master (
    .d(d_muxed),
    .en(clk),
    .q(master_latch_out)
);

// Slave latch (positive level-sensitive)
DLatch slave (
    .d(master_latch_out),
    .en(clk_inv),
    .q(slave_latch_out)
);

// Output assignment
assign q = slave_latch_out;

endmodule

// Basic D-latch module
module DLatch (
    input wire d,
    input wire en,
    output reg q
);
always @*
    if (en) q = d;
endmodule