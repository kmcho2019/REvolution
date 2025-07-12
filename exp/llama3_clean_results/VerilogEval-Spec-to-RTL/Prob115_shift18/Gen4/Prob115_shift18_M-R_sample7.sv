module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;
wire [63:0] shift_left_1, shift_left_8, shift_right_1, shift_right_8;

assign shift_left_1 = {q_reg[62:0], 1'b0}; // Shift left by 1
assign shift_left_8 = {q_reg[55:0], 8'b0}; // Shift left by 8
assign shift_right_1 = q_reg >>> 1; // Arithmetic right shift by 1
assign shift_right_8 = q_reg >>> 8; // Arithmetic right shift by 8

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    case (amount)
      2'b00: q_reg <= shift_left_1; // Shift left by 1
      2'b01: q_reg <= shift_left_8; // Shift left by 8
      2'b10: q_reg <= shift_right_1; // Arithmetic right shift by 1
      2'b11: q_reg <= shift_right_8; // Arithmetic right shift by 8
    endcase
  end
end

assign q = q_reg;

endmodule