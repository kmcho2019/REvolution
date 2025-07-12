module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

parameter WIDTH = 64;

reg [WIDTH-1:0] q_reg;

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    case (amount)
      2'b00: q_reg <= {q_reg[WIDTH-2:0], 1'b0}; // shift left by 1 bit
      2'b01: q_reg <= {q_reg[WIDTH-9:0], {8{1'b0}}}; // shift left by 8 bits
      2'b10: q_reg <= {q_reg[WIDTH-1], q_reg[WIDTH-1:1]}; // shift right by 1 bit (arithmetic)
      2'b11: q_reg <= {{8{q_reg[WIDTH-1]}}, q_reg[WIDTH-1:8]}; // shift right by 8 bits (arithmetic)
      default: q_reg <= q_reg;
    endcase
  end else begin
    q_reg <= q_reg;
  end
end

assign q = q_reg;

endmodule