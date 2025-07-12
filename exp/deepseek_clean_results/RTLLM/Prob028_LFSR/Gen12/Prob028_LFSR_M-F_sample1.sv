module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state
);

// Internal state register
reg [3:0] state;

// Feedback is XOR of bits 3 and 2 (tap positions for x^4 + x^3 + 1 polynomial)
wire feedback = state[3] ^ state[2];

always @(posedge clk) begin
    if (rst) begin
        // Initialize to non-zero state to prevent lock-up
        state <= 4'b0001;
    end
    else begin
        // Standard LFSR operation: shift left and insert feedback
        state <= {state[2:0], feedback};
    end
end

// Output is simply the current state
always @(*) begin
    out = state;
end

endmodule