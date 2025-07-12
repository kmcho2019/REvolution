module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;
reg [63:0] next_q;

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    q_reg <= next_q;
  end
end

always @(*) begin
  case (amount)
    2'b00: next_q = q_reg << 1; // Shift left by 1
    2'b01: next_q = q_reg << 8; // Shift left by 8
    2'b10: next_q = {q_reg[63], q_reg[63:1]}; // Arithmetic right shift by 1
    2'b11: next_q = {{56{q_reg[63]}}, q_reg[63:8]}; // Arithmetic right shift by 8
    default: next_q = q_reg; // No shift when ena is low
  endcase
end

assign q = q_reg;

endmodule