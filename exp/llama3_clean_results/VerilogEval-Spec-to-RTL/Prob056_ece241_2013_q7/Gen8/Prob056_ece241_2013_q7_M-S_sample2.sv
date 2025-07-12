module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0;

always @(posedge clk)
    Q <= (j == 0 && k == 0) ? Q :
         (j == 0 && k == 1) ? 0 :
         (j == 1 && k == 0) ? 1 :
         (j == 1 && k == 1) ? ~Q : Q;

endmodule