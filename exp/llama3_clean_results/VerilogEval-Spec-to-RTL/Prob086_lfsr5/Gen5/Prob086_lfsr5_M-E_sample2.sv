module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b1; // Reset to a non-zero value to generate the maximum-length sequence
    end else begin
        state[0] <= state[4] ^ state[2]; // Tap positions 5 and 3 (0-indexed)
        state[1] <= state[0];
        state[2] <= state[1];
        state[3] <= state[2];
        state[4] <= state[3];
    end
end

assign q = state;

endmodule