module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to 1
    end else begin
        // Calculate the next state
        reg [4:0] nextState;
        assign nextState[4] = state[3];
        assign nextState[3] = state[2];
        assign nextState[2] = state[1];
        assign nextState[1] = state[0];
        assign nextState[0] = state[4] ^ state[2];
        state <= nextState;
    end
end

assign q = state; // Output the current state of the LFSR

endmodule