module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0
);

always @(posedge clk) begin
    Q <= (j & ~k) ? 1'b1 : (~j & k) ? 1'b0 : (j & k) ? ~Q : Q;
end

endmodule