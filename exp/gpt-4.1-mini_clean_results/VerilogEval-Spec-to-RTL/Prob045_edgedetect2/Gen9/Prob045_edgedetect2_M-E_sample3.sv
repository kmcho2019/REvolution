module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    // 2-bit shift register per bit storing current and previous inputs
    reg [1:0] shift_reg [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in current bit of input
            shift_reg[i] <= {shift_reg[i][0], in[i]};
            // Compare stored bits to detect edge
            anyedge[i] <= (shift_reg[i][1] ^ shift_reg[i][0]);
        end
    end
endmodule