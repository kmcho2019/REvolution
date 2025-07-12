module LFSR #(
    parameter WIDTH = 4,                      // Register width
    parameter SEED = 4'b0001,                 // Initial seed value
    parameter [WIDTH-1:0] TAPS = 4'b1100      // Feedback taps (standard for 4-bit LFSR)
) (
    input  wire               clk,            // Clock input
    input  wire               rst,            // Synchronous reset
    output reg  [WIDTH-1:0]   out,            // Current LFSR state
    output wire               valid           // High when LFSR is initialized
);

// Feedback polynomial calculation (XOR of tapped bits)
wire feedback = ^(out & TAPS);

// Valid signal indicates LFSR is initialized (not in reset state)
assign valid = ~rst;

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;  // Initialize with seed value
    end else begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
end

// Documentation
// This implements a maximal-length 4-bit LFSR with period 2^4-1 = 15
// Feedback taps follow the polynomial x^4 + x^3 + 1
// For WIDTH=4, TAPS should be 4'b1100 (bits 3 and 2)

endmodule