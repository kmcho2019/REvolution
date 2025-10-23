// Novel LFSR implementation using lookup table and modular arithmetic
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Lookup table for next state calculation
reg [3:0] next_state [15:0];

// Initialize lookup table
initial begin
    for (int i = 0; i < 16; i++) begin
        // Precompute next state for each possible current state
        // For example, using the XOR of MSB and second MSB as feedback
        next_state[i] = {i[2:0], ~(i[3] ^ i[2])};
    end
end

// Use lookup table to determine next state
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        // Use modular arithmetic to wrap around the shift register
        out <= next_state[out];  // Determine next state using lookup table
    end
end

endmodule