module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg next_Q;

always @(*) begin
    if (L)
        next_Q = R;
    else if (E)
        next_Q = w;
    else
        next_Q = Q;
end

always @(posedge clk) begin
    // Update only if load or enable asserted, or if next_Q differs from current Q
    // This avoids unnecessary toggling and redundant writes
    if (L || E || (next_Q != Q))
        Q <= next_Q;
end

endmodule