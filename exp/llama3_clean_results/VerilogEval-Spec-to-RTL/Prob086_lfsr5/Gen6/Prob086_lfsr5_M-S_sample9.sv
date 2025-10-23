module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;
assign q = state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Reset state to a known non-zero value
    end else begin
        state <= {state[4] ^ state[2] ^ state[0], state[4:1]}; // Correct LFSR next state calculation
    end
end

initial begin
    state = 5'b10000; // Initialize state with a known non-zero value
end

endmodule