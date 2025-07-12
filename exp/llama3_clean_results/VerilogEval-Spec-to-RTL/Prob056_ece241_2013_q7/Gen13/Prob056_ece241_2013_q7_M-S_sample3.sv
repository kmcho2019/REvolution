module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0
);

always @(posedge clk)
    Q <= (j == 1'b0 && k == 1'b0) ? Q : 
         (j == 1'b0 && k == 1'b1) ? 1'b0 : 
         (j == 1'b1 && k == 1'b0) ? 1'b1 : 
         ~Q;

endmodule