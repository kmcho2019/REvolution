module DFF_neg_edge_sync_reset (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q,
    input wire reset_val
);
    // Single bit D flip-flop triggered on negedge clk
    // Synchronous active-high reset loads reset_val (bit of 0x34)
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // Define the reset value constant 0x34 bits
    localparam [7:0] RESET_VAL = 8'h34;

    // Instantiate 8 individual DFF bits
    DFF_neg_edge_sync_reset dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]), .reset_val(RESET_VAL[0]));
    DFF_neg_edge_sync_reset dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]), .reset_val(RESET_VAL[1]));
    DFF_neg_edge_sync_reset dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]), .reset_val(RESET_VAL[2]));
    DFF_neg_edge_sync_reset dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]), .reset_val(RESET_VAL[3]));
    DFF_neg_edge_sync_reset dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]), .reset_val(RESET_VAL[4]));
    DFF_neg_edge_sync_reset dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]), .reset_val(RESET_VAL[5]));
    DFF_neg_edge_sync_reset dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]), .reset_val(RESET_VAL[6]));
    DFF_neg_edge_sync_reset dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]), .reset_val(RESET_VAL[7]));
endmodule