module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    if (b)
        next_state = ~a;
    else
        next_state = state;

    if (b)
        q = a;
    else
        q = state;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule