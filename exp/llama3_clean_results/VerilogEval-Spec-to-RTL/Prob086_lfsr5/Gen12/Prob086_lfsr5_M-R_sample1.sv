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
        state[4] <= state[3] ^ state[0]; // MSB is tapped
        state[3] <= state[2] ^ state[0]; // Second tapped bit
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state[4]; // LSB shifts in the new MSB value
    end
end

assign q = state; // Output the current state of the LFSR

endmodule