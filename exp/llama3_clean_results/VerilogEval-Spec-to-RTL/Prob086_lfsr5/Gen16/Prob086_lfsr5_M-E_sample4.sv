module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

parameter TAP1 = 4; // Tap at position 5 (4 in 0-based indexing)
parameter TAP2 = 2; // Tap at position 3 (2 in 0-based indexing)

reg [4:0] state; // Current state of the LFSR
reg [4:0] nextState; // Next state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to 1
    end else begin
        reg tmp;
        tmp = state[TAP1] ^ state[TAP2] ^ state[0]; // XOR operation between taps and LSB
        nextState = {tmp, state[4:1]}; // Update the state with the next state
        state <= nextState;
    end
end

assign q = state; // Output the current state of the LFSR

endmodule