/**
 * Enhanced Parameterized D Flip-Flop with:
 * - Synchronous reset (default)
 * - Optional async reset
 * - Clock gating
 * - Buffered reset
 * - Registered outputs
 */
module DFF #(
    parameter WIDTH = 1,
    parameter ASYNC_RESET = 0  // 0=sync (default), 1=async
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input en = 1'b1  // Optional clock enable
);

// Buffered reset for lower switching power
wire reset_buf;
BUFX1 reset_buf_inst (.A(reset), .Y(reset_buf));

// Clock gating cell
wire gated_clk;
CLKGATE_X1 clk_gate_inst (
    .CK(clk),
    .E(en && (|(d ^ q) || reset_buf)),  // Only clock when data changes or reset
    .GCK(gated_clk)
);

generate
    if (ASYNC_RESET) begin: async_rst
        always @(posedge gated_clk or posedge reset_buf) begin
            if (reset_buf) q <= {WIDTH{1'b0}};
            else          q <= d;
        end
    end else begin: sync_rst
        always @(posedge gated_clk) begin
            if (reset_buf) q <= {WIDTH{1'b0}};
            else          q <= d;
        end
    end
endgenerate

endmodule

/**
 * Optimized Top Module with:
 * - Clock gating awareness
 * - Output buffering
 * - Reset isolation
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Internal signals
wire [7:0] q_int;

// Main register array with clock gating
DFF #(.WIDTH(8)) dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q_int),
    .en(1'b1)  // Enable always on (can be controlled externally)
);

// Output buffer registers for better timing
DFF #(.WIDTH(8)) out_buf (
    .clk(clk),
    .reset(1'b0),  // No reset on output buffers
    .d(q_int),
    .q(q)
);

endmodule