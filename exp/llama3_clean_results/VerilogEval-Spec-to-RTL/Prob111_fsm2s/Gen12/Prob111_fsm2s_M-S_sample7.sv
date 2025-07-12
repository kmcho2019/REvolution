module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state, next_state;

always @(*) begin
    case(state)
        0: next_state = (j) ? 1 : 0;
        1: next_state = (k) ? 0 : 1;
        default: next_state = 0;
    endcase
end

always @(posedge clk) begin
    if (reset) state <= 0;
    else state <= next_state;
    out <= (state == 1);
end

endmodule