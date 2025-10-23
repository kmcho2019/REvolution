module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg next_Q;
wire ce; // clock enable

always @(*) begin
    if (L)
        next_Q = R;
    else if (E)
        next_Q = w;
    else
        next_Q = Q;
end

assign ce = (next_Q != Q);

always @(posedge clk) begin
    if (ce)
        Q <= next_Q;
end

endmodule