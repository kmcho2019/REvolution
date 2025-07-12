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
        state <= {state[4] ^ state[2] ^ state[0], state[4:1]}; // Update the state with the next state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule