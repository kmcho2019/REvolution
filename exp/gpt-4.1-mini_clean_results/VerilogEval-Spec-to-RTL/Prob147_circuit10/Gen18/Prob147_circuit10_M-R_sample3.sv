module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    next_state = state ^ (b & ~a);
    q = (state & ~a) | b;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule