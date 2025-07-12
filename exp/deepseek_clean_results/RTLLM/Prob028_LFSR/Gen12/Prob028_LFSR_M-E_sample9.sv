module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state
);

wire [3:0] next_state;

// Enhanced feedback polynomial: XOR of bits 3, 2, and 0, then inverted
assign next_state[0] = ~(out[3] ^ out[2] ^ out[0]);
assign next_state[3:1] = out[2:0];  // Shift left

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;    // Reset to all zeros
    end else begin
        out <= next_state; // Parallel load of next state
    end
end

endmodule