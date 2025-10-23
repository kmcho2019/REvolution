module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to a 5-bit value
    end else begin
        reg [4:0] temp_state;
        temp_state = {state[3:0], 1'b0}; // Shift the current state to the right
        temp_state[4] = state[4] ^ state[0]; // Tap at position 5 (4 in 0-based indexing)
        temp_state[2] = state[3] ^ state[0]; // Tap at position 3 (2 in 0-based indexing)
        state <= temp_state; // Update the state with the next state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule