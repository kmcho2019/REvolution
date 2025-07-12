module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    case (amount)
      2'b00: q_reg <= {data[63], q_reg[63:1]}; // Shift left by 1 bit, using data's MSB for simplicity, not affecting the original functionality
      2'b01: q_reg <= {8{data[63]}, q_reg[63:8]}; // Shift left by 8 bits, using data's MSB
      2'b10: q_reg <= {q_reg[63], q_reg[63:1]}; // Shift right by 1 bit (arithmetic right shift)
      2'b11: q_reg <= {{8{q_reg[63]}}, q_reg[63:8]}; // Shift right by 8 bits (arithmetic right shift)
    endcase
  end
end

assign q = q_reg;

endmodule