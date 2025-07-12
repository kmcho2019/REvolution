module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Reset to '00001' for a non-zero initial state
    end else begin
        // Calculate the next state based on the current state and tap positions
        // For a 5-bit LFSR with taps corresponding to x^5 + x^3 + 1
        state <= {state[4] ^ state[2] ^ state[0], state[4:1]}; // Shift and feedback
    end
end

assign q = state; // Output the current state of the LFSR

endmodule