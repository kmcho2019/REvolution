module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Corrected reset value
    end else begin
        // Calculate the next state
        state[4] <= state[3]; // Shift right
        state[3] <= state[2]; // Shift right
        state[2] <= state[1]; // Shift right
        state[1] <= state[0]; // Shift right
        state[0] <= state[4] ^ state[2]; // XOR with taps
    end
end

assign q = state; // Output the current state of the LFSR

endmodule