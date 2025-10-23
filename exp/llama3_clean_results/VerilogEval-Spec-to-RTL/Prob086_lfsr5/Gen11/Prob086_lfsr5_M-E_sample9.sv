module LFSRNextState(
    input [4:0] state,
    output [4:0] next_state
);

assign next_state[4] = state[3] ^ state[0]; // Tap at position 5
assign next_state[3] = state[2]; // Shift right
assign next_state[2] = state[1] ^ state[0]; // Tap at position 3
assign next_state[1] = state[0]; // Shift right
assign next_state[0] = state[4] ^ state[2]; // Shift right and XOR

endmodule

module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

LFSRNextState next_state_module(
    .state(state),
    .next_state(state)
);

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        state <= state; // Update the state using the next_state_module
        state[4] <= state[3] ^ state[0]; 
        state[3] <= state[2]; 
        state[2] <= state[1] ^ state[0]; 
        state[1] <= state[0]; 
        state[0] <= state[4] ^ state[2]; 
    end
end

assign q = state; // Output the current state of the LFSR

endmodule