module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] shift_reg [1:0]; // 2-stage shift register for input history

    always @(posedge clk) begin
        shift_reg[1] <= shift_reg[0];
        shift_reg[0] <= in;

        pedge <= (~shift_reg[1]) & shift_reg[0];
    end

endmodule