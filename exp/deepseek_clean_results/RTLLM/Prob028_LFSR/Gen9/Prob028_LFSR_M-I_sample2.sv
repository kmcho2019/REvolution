module LFSR #(
    parameter WIDTH = 4         // Configurable width
) (
    input wire clk,             // Clock input
    input wire rst,             // Active high synchronous reset
    input wire en,              // Enable signal (active high)
    output reg [WIDTH-1:0] out, // LFSR state output
    output wire fb_out          // Feedback output (optional)
);

// Feedback polynomial: x^4 + x^3 + 1 (standard maximal-length LFSR)
// Taps at bits 3 and 2 (for 4-bit LFSR)
assign fb_out = out[WIDTH-1] ^ out[WIDTH-2];

always @(posedge clk) begin
    if (rst) begin
        // Initialize to non-zero value (avoid lock-up at 0000)
        out <= {{(WIDTH-1){1'b0}}, 1'b1};
    end else if (en) begin
        // Shift left and insert feedback at LSB
        out <= {out[WIDTH-2:0], fb_out};
    end
end

// Formal property: LFSR will cycle through 2^WIDTH-1 states (maximal length)
// Note: Requires WIDTH=4 and polynomial x^4 + x^3 + 1 for 15-state sequence

endmodule