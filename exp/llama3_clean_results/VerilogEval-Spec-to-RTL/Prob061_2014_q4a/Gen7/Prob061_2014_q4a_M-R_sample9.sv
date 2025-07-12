module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg next_Q;

always @(*) begin
    if (L) begin
        next_Q = R;
    end else if (E) begin
        next_Q = w;
    end else begin
        next_Q = Q;
    end
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule