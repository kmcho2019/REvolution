module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0; // Initialize Q to 0 at the start of the simulation

always @(posedge clk) begin
    Q <= (j == 1'b0 && k == 1'b0)? Q :
         (j == 1'b0 && k == 1'b1)? 1'b0 :
         (j == 1'b1 && k == 1'b0)? 1'b1 :
         (j == 1'b1 && k == 1'b1)? ~Q : Q;
end

endmodule