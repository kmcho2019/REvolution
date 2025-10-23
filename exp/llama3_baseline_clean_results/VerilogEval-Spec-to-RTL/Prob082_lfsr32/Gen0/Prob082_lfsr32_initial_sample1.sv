module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 32'h1;
    end else begin
        state[31] <= state[30];
        state[30:22] <= state[29:21];
        state[21:2] <= state[20:1];
        state[1] <= state[0] ^ state[30];
        state[0] <= state[31] ^ state[30] ^ state[1];
    end
end

assign q = state;

endmodule