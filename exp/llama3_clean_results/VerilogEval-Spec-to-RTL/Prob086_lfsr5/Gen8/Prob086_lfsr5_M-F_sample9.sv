module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else begin
        state[4] <= state[3] ^ state[0]; // Tap at position 5
        state[3] <= state[2] ^ state[0]; // Tap at position 3
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state[4]; // This will be the new MSB after the shift
    end
end

assign q = state; // Output the current state of the LFSR

endmodule