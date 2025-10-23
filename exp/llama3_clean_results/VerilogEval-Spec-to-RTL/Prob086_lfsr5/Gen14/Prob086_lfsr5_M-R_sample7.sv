module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a non-zero state for maximal-length sequence
    end else begin
        // Calculate the next state based on the current state and tap positions
        // For a 5-bit LFSR with taps at positions corresponding to x^5 + x^2 + 1
        state <= {state[3] ^ state[0], state[4:1]}; // Shift and feedback
    end
end

assign q = state; // Output the current state of the LFSR

endmodule