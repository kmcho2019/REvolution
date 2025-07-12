module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [1:0] shift_reg [7:0];  // For each bit, store two consecutive samples

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= {shift_reg[i][0], in[i]};
            anyedge[i] <= (shift_reg[i][1] ^ shift_reg[i][0]);
        end
    end
endmodule