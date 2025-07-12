module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state
);

reg [3:0] state;
reg [3:0] prev_state;
wire feedback;
wire [1:0] parity;

// Calculate parity of current state (count of 1s)
assign parity = state[0] + state[1] + state[2] + state[3];

// Dynamic feedback selection:
// Even parity: XOR bits 3 and 2 (conventional)
// Odd parity: XOR bits 3 and 1 (alternative polynomial)
assign feedback = (parity[0]) ? state[3] ^ state[1] : state[3] ^ state[2];

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;      // Initialize to non-zero state
        prev_state <= 4'b0000;
    end
    else begin
        prev_state <= state;
        
        // Normal operation: shift left and insert feedback
        if (state != 4'b0000) begin
            state <= {state[2:0], feedback};
        end
        // Auto-seeding if we somehow reach all zeros
        else begin
            state <= prev_state ^ 4'b1010;  // Reseed with previous state XOR pattern
        end
    end
end

// Output transformation: XOR with rotated version to break linearity
always @(*) begin
    out = state ^ {state[0], state[3:1]};
end

endmodule