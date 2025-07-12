module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [1:0] shift_reg [7:0];  // 2-bit shift register per input bit

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in the current bit sample
            shift_reg[i] <= {shift_reg[i][0], in[i]};
            // Detect edge by comparing the last two samples
            anyedge[i] <= (shift_reg[i][1] != shift_reg[i][0]);
        end
    end

endmodule