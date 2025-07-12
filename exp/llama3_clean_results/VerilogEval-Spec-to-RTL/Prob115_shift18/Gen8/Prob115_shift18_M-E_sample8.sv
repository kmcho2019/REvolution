module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

wire [63:0] shifted_q;

// Barrel shifter
always @(*) begin
  case (amount)
    2'b00: shifted_q = {q_reg[62:0], 1'b0};
    2'b01: shifted_q = {q_reg[55:0], 8'b0};
    2'b10: shifted_q = {q_reg[63], q_reg[63:1]};
    2'b11: shifted_q = {q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63:8]};
    default: shifted_q = q_reg;
  endcase
end

// Clock-gated load controller
always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    q_reg <= shifted_q;
  end
end

assign q = q_reg;

endmodule