module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000;  // Reset to '1' as per the requirement
    end else begin
        state[4] <= state[3] ^ state[0];  // Tap at position 5
        state[3] <= state[2] ^ state[0];  // Tap at position 3
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= 0;  // Since we're shifting right, the new LSB is always 0
    end
end

assign q = state;

endmodule