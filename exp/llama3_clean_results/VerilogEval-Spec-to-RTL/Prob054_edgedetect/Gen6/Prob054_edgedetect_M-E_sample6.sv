module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] shift_reg;  // 8-bit shift register to store the previous input

always @(posedge clk) begin
    // Shift the current input into the shift register
    shift_reg <= {shift_reg[6:0], in[7]};
    
    // Compare the current input with the previous state stored in the shift register
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= (shift_reg[i] == 1'b0 && in[i] == 1'b1) ? 1'b1 : 1'b0;
    end
end

endmodule