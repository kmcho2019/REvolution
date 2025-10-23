module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b1; // Initialize the LFSR with a non-zero state (1)
    end else begin
        // Calculate the next state of the LFSR based on the current state and the XOR of the tap positions
        state <= {state[4] ^ state[2], state[4], state[3], state[2], state[1]};
    end
end

assign q = state; // Output the current state of the LFSR

endmodule