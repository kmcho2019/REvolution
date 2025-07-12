module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 0: OFF, 1: ON

always @(posedge clk) begin
    if (reset) state <= 0;
    else state <= (state == 0 && j) || (state == 1 &&!k);
end

assign out = state;

endmodule