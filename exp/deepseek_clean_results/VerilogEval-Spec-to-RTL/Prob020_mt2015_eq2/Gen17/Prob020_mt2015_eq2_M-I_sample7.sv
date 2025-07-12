module TopModule (
    input clk,        // Clock for synchronization
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    reg [1:0] A_reg, B_reg;
    
    always @(posedge clk) begin
        A_reg <= A;
        B_reg <= B;
        z <= (A_reg[1] ~^ B_reg[1]) & (A_reg[0] ~^ B_reg[0]);
    end
endmodule