module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] shift_reg1, shift_reg2;

    always @(posedge clk) begin
        shift_reg1 <= in;
        shift_reg2 <= shift_reg1;
        anyedge <= shift_reg1 ^ shift_reg2;
    end
endmodule