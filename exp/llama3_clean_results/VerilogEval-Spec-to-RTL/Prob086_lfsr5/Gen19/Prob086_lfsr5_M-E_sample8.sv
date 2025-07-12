module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Initialize the LFSR with a non-zero state
initial begin
    state = 5'b10001; // Initialize with a valid state
end

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10001; // Reset to a valid state
    end else begin
        // Shift the bits to the right
        reg [4:0] next_state;
        next_state[4] = state[0] ^ state[2]; // Feedback for the MSB
        next_state[3] = state[4];
        next_state[2] = state[3];
        next_state[1] = state[2];
        next_state[0] = state[1];
        
        state <= next_state;
    end
end

assign q = state; // Output the current state of the LFSR

endmodule