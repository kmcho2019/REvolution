module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to a single '1'
    end else begin
        state <= {state[2] ^ state[0], state[4:1]}; // Tap at position 5 and 3
    end
end

assign q = state;

endmodule