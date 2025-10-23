module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 32'h1;
    end else begin
        reg [31:0] next_state;
        next_state = state >> 1;
        next_state[31] = state[0] ^ state[22] ^ state[2] ^ state[1];
        state <= next_state;
    end
end

assign q = state;

endmodule