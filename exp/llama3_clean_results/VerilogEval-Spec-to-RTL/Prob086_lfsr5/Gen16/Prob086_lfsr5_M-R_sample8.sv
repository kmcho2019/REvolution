module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to 1 (5'b10000 is 1 in binary with the first bit at the MSB position)
    end else begin
        // Calculate the next state
        state[4] <= state[3] ^ state[0]; // Tap at position 5 (4 in 0-based indexing)
        state[3] <= state[2] ^ state[0]; // Tap at position 3 (2 in 0-based indexing)
        state[2] <= state[1]; // No tap, just shift right
        state[1] <= state[0]; // No tap, just shift right
        state[0] <= state[4]; // Shift the MSB to the LSB
    end
end

assign q = state; // Output the current state of the LFSR

endmodule