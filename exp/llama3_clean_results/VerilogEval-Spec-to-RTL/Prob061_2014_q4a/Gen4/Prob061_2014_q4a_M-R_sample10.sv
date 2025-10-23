module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg next_Q;

assign next_Q = (L) ? R : ((E) ? w : Q);

always_ff @(posedge clk) begin
    Q <= next_Q;
end

endmodule