// Improved solution
module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) 
    Q <= (L == 1'b1)? R : (E == 1'b1)? w : Q;

endmodule