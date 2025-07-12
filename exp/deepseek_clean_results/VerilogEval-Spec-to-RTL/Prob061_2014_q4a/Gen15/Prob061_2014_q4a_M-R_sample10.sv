module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg next_Q;

always @(*) begin
    case (1'b1)
        L: next_Q = R;
        E: next_Q = w;
        default: next_Q = Q;
    endcase
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule