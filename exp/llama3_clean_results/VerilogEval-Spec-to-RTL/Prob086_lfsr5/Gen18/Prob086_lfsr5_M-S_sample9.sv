module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the state register
always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Set the LFSR output to 1
    end else begin
        // Calculate the next state
        state <= {state[3] ^ state[0], state[2] ^ state[0], state[1], state[0], 0};
    end
end

assign q = state; // Output the current state of the LFSR

endmodule