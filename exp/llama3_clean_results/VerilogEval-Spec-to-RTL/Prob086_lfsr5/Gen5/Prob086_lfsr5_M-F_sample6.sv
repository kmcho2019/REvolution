module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Initialize the LFSR state to 1 when reset is high
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        // Apply the Galois LFSR equation: x^5 + x^3 + 1 = 0
        // Shift right and XOR tap positions with the LSB
        state <= {state[3:0], state[4] ^ state[2]}; // taps at positions 5 and 3
    end
end

assign q = state; // Output the current state of the LFSR

endmodule