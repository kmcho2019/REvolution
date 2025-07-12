module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;
assign q = state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // Reset to a non-zero state
    end else begin
        state[4] <= state[3] ^ state[0]; // Tap at position 5
        state[3] <= state[2] ^ state[0]; // Tap at position 3
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= 1'b0; // Shift in a 0 from the left
    end
end

endmodule