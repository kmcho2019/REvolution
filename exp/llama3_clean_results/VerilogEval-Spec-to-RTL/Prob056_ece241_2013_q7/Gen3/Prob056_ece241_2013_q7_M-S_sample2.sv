module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j == 0 && k == 0) ? Q :
         (j == 0) ? 0 :
         (k == 0) ? 1 :
         ~Q;
end

endmodule