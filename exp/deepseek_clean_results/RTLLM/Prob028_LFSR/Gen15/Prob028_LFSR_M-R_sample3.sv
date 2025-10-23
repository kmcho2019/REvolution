module LFSR #(
    parameter WIDTH = 4,                      // Register width
    parameter SEED = 4'b0001,                 // Initial seed value
    parameter [WIDTH-1:0] TAPS = 4'b1100      // Feedback taps (standard for 4-bit LFSR)
) (
    input  wire               clk,            // Clock input
    input  wire               rst,            // Synchronous reset
    output wire [WIDTH-1:0]   out,            // Current LFSR state
    output wire               valid           // High when LFSR is initialized
);

// Internal state register
reg [WIDTH-1:0] state;

// Feedback calculation (combinational)
wire feedback = ^(state & TAPS);

// Next state logic (combinational)
wire [WIDTH-1:0] next_state = rst ? SEED : {state[WIDTH-2:0], feedback};

// State update (sequential)
always @(posedge clk) begin
    state <= next_state;
end

// Output assignments
assign out = state;
assign valid = ~rst;

// Documentation
// This implements a maximal-length 4-bit LFSR with period 2^4-1 = 15
// Feedback taps follow the polynomial x^4 + x^3 + 1
// For WIDTH=4, TAPS should be 4'b1100 (bits 3 and 2)

endmodule