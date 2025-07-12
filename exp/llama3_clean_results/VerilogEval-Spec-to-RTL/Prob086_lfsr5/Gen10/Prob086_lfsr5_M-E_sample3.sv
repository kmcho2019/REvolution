module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Initialize the LFSR to a non-zero state
    end else begin
        // Calculate the next state based on the taps at positions 5 and 3
        state[0] <= state[4]; // Shift the MSB to the LSB position
        state[1] <= state[0]; // Shift bit 0 to bit 1
        state[2] <= state[1]; // Shift bit 1 to bit 2
        state[3] <= state[2]; // Shift bit 2 to bit 3
        state[4] <= state[3] ^ state[0]; // Update the MSB based on the tap positions
    end
end

assign q = state; // Output the current state of the LFSR

endmodule