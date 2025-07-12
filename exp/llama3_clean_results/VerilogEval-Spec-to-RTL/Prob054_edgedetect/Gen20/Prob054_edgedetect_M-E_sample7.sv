module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg [1:0]; // 2-stage shift register to store current and previous inputs

always @(posedge clk) begin
    shift_reg[0] <= in; // Shift in the new input
    shift_reg[1] <= shift_reg[0]; // Shift the previous input to the next stage
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = in[i] & ~shift_reg[1][i]; // Detect edge by comparing current and previous inputs
    end
end

endmodule