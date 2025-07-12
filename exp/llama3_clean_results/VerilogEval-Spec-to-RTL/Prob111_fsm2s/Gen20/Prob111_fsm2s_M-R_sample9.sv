module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 0: OFF, 1: ON
reg next_state;

always @(posedge clk) begin
    if (reset) state <= 0;
    else state <= next_state;
end

always @(*) begin
    case (state)
        0: next_state = j ? 1 : 0;
        1: next_state = ~k ? 1 : 0;
    endcase
end

assign out = state;

endmodule