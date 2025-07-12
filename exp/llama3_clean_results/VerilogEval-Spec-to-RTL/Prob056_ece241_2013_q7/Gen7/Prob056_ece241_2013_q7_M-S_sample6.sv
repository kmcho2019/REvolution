module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & ~k)? 1 : (k & ~j)? 0 : ~j & ~k? Q : ~Q;
end

endmodule