module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;
reg [63:0] temp_reg;

wire [63:0] next_q;

assign next_q = (load)? data :
                 (ena)? (
                   (amount == 2'b00)? {q_reg[62:0], q_reg[63]} :
                   (amount == 2'b01)? {q_reg[55:0], {8{q_reg[63]}} } :
                   (amount == 2'b10)? {q_reg[63], q_reg[63:1]} :
                   (amount == 2'b11)? {q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63:8]} :
                   q_reg
                 ) :
                 q_reg;

always @(posedge clk) begin
  if (ena) begin
    if (load)
      q_reg <= data;
    else
      q_reg <= next_q;
  end
end

assign q = q_reg;

endmodule