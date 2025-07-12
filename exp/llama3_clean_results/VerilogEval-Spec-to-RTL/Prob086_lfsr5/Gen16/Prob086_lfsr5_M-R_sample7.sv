module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Initial state when reset is high
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR output to 1
    end
end

// Calculate the next state based on the current state and taps
always @(posedge clk) begin
    if (!reset) begin
        // Temporary variable to hold the next state
        reg [4:0] nextState;
        
        // Calculate the new state
        nextState[4] = q[3]; // MSB comes from the bit at position 3
        nextState[3] = q[2]; // Bit at position 3 comes from the bit at position 2
        nextState[2] = q[1]; // Bit at position 2 comes from the bit at position 1
        nextState[1] = q[0]; // Bit at position 1 comes from the bit at position 0
        // Calculate the new LSB as the XOR of the current bits at the tap positions
        nextState[0] = q[4] ^ q[2]; // Taps at positions 5 and 3 influence the new LSB
        
        // Update the current state with the next state
        q <= nextState;
    end
end

endmodule