module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR
wire [4:0] nextState; // Next state of the LFSR

// Calculate the next state
assign nextState[4] = state[3] ^ state[0]; // Tap at position 5 (4 in 0-based indexing)
assign nextState[3] = state[2]; // No tap, just shift right
assign nextState[2] = state[1] ^ state[0]; // Tap at position 3 (2 in 0-based indexing)
assign nextState[1] = state[0]; // No tap, just shift right
assign nextState[0] = state[4]; // The LSB is the MSB of the current state

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to 1
    end else begin
        state <= nextState; // Update the state with the next state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule