module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        reg [4:0] next_state;
        next_state[4] = state[3] ^ state[0]; // Tap at position 5
        next_state[3] = state[2]; // Shift right
        next_state[2] = state[1] ^ state[0]; // Tap at position 3
        next_state[1] = state[0]; // Shift right
        next_state[0] = state[4]; // Shift right
        state <= next_state;
    end
end

assign q = state; // Output the current state of the LFSR

endmodule