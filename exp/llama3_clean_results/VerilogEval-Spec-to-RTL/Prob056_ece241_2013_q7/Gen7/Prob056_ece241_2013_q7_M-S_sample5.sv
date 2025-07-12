module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

initial Q = 0; // Initialize Q to 0 at the start of the simulation

always @(posedge clk) begin
    Q <= (j == 0 && k == 0) ? Q :
         (j == 0 && k == 1) ? 0 :
         (j == 1 && k == 0) ? 1 :
         (j == 1 && k == 1) ? ~Q : Q;
end

endmodule