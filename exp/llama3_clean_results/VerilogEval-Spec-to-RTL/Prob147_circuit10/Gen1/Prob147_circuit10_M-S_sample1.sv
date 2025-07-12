module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= state ^ a;
    q <= (state ^ a) ^ b;
end

endmodule