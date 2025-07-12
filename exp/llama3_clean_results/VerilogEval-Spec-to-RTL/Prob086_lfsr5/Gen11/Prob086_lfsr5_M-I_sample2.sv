module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Reset the LFSR to the desired initial state
    end else begin
        // Correct implementation for a 5-bit Galois LFSR with taps at positions 5 and 3:
        // Calculate the new MSB by XORing the bits at tap positions and the LSB
        state <= {state[2] ^ state[4] ^ state[0], state[4:1]}; // Update the state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule