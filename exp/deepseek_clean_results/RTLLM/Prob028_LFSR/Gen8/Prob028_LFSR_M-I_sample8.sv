module LFSR #(
    parameter WIDTH = 4
) (
    input clk,
    input rst,
    input en,           // Enable signal (active high)
    input load,         // Parallel load enable
    input [WIDTH-1:0] seed, // Initial seed value
    output reg [WIDTH-1:0] out
);

// Feedback calculation (XOR of bits 3 and 2)
wire feedback = out[WIDTH-1] ^ out[WIDTH-2];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= {WIDTH{1'b0}};  // Active high reset
    end else if (load) begin
        out <= seed;           // Parallel load
    end else if (en) begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
    // If not enabled, maintain current state (low power)
end

endmodule