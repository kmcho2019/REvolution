module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10001; // Initialize state with reset
    end else begin
        state[4] <= state[4] ^ state[0]; // Tap at position 5
        state[2] <= state[2] ^ state[0]; // Tap at position 3
        state[3:0] <= state[3:0] >> 1; // Shift right
        state[4] <= state[3]; // Update MSB after shift
    end
end

assign q = state;

endmodule