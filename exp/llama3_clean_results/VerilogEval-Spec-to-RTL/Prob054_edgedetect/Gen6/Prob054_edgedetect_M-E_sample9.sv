module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [15:0] shift_reg;  // 16-bit shift register to store previous and current state

always @(posedge clk) begin
    shift_reg <= {in, shift_reg[7:0]};  // update shift register
    pedge <= shift_reg[7:0] & ~shift_reg[15:8];  // detect positive edge transitions
end

endmodule