module TopModule (
  input clk,
  input L,
  input [2:0] q_in,
  input [2:0] r_in,
  output reg [2:0] Q
);

  reg [2:0] Q_reg;

  always @(posedge clk) begin
    if (L)
      Q_reg <= r_in;
    else
      Q_reg <= {Q_reg[1] ^ Q_reg[2], Q_reg[0], Q_reg[2]};
  end

  assign Q = L ? r_in : Q_reg;

endmodule