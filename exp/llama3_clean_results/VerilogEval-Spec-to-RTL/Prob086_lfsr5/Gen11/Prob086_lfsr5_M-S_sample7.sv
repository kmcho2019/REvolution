module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        state[4] <= state[3] ^ state[0]; // Update MSB with tap at position 3
        state[3] <= state[2] ^ state[0]; // Update bit 3 with tap at position 3 (since 5 is out of bounds for 5-bit)
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state[4]; // Shift the MSB into the LSB position
    end
end

assign q = state; // Output the current state of the LFSR

endmodule