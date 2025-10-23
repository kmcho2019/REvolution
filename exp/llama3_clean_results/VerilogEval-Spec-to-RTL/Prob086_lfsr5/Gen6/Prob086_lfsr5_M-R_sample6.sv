module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR
reg [4:0] next_state; // Next state of the LFSR

// Compute the next state of the LFSR
assign next_state[4] = state[3]; // Shift right
assign next_state[3] = state[2] ^ state[0]; // Tap at position 3
assign next_state[2] = state[1]; // Shift right
assign next_state[1] = state[0]; // Shift right
assign next_state[0] = state[4] ^ state[2] ^ state[0]; // Tap at position 5 and feedback

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        state <= next_state; // Update the current state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule