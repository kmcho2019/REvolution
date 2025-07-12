module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000;
    end else begin
        state <= {state[3] ^ state[0], state[2] ^ state[0], state[1], state[0], 1'b0};
    end
end

assign q = state;

endmodule