module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // Next state logic: next_state = (a & b) | (state & ~a)
    next_state = (a & b) | (state & ~a);

    // Output logic: q = state ^ b
    q = state ^ b;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule