module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

assign q = state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset state to a known value
    end else begin
        // Compute next state for bits with taps (positions 5 and 3)
        reg [4:0] nextState;
        nextState[4] = state[3] ^ state[0]; // Tap at position 5
        nextState[2] = state[1] ^ state[0]; // Tap at position 3
        // Right shift for other bits
        nextState[3] = state[2];
        nextState[1] = state[1];
        nextState[0] = state[0];
        state <= {nextState[4], nextState[3], nextState[2], nextState[1], state[0]}; // Update state
    end
end

initial begin
    state = 5'b10000; // Initialize state with a known value
end

endmodule