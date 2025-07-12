module LFSR #(
    parameter WIDTH = 4          // Configurable width
)(
    input wire clk,              // Clock
    input wire rst,              // Active-high synchronous reset
    input wire en,               // Enable signal
    output reg [WIDTH-1:0] out,  // LFSR state output
    output wire valid            // Output valid (always 1 when enabled)
);

// Feedback calculation optimized: ~(out[MSB] ^ out[MSB-1])
wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

assign valid = en;  // Output is valid when enabled

always @(posedge clk) begin
    if (rst) begin
        out <= {WIDTH{1'b1}};  // Reset to all 1's for better randomness
    end
    else if (en) begin
        // Shift left and insert feedback at LSB
        out <= {out[WIDTH-2:0], feedback};
    end
end

endmodule