module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Qold;

always @(posedge clk) begin
    Qold <= Q;
    Q <= (j && ~k)? 1'b1 : (k && ~j)? 1'b0 : (~j && ~k)? Q : ~Q;
end

initial begin
    Qold = 1'b0;
    Q = 1'b0;
end

endmodule