module LFSR #(
    parameter WIDTH = 4,                     // Configurable width
    parameter RESET_VAL = 4'b0001,            // Non-zero initial state
    parameter POLY_TAPS = 4'b1100             // Taps for bits 3 and 2
)(
    input  wire clk,                          // Clock input
    input  wire rst,                          // Synchronous reset
    output reg  [WIDTH-1:0] out,              // LFSR output
    output wire out_valid                     // Optional valid signal
);

// Feedback calculation without inversion (standard LFSR form)
wire feedback = ^(out & POLY_TAPS);

// Optional output register
assign out_valid = ~rst;

always @(posedge clk) begin
    if (rst) begin
        out <= RESET_VAL;                    // Initialize to non-zero value
    end else begin
        out <= {out[WIDTH-2:0], feedback};   // Standard LFSR operation
    end
end

endmodule