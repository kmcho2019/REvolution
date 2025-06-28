module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg [2:0] q_reg;

  always @ (posedge clk)
    if (L)
      q_reg <= r_in;
    else
      q_reg <= {q_reg[1] ^ q_reg[2], q_reg[0], q_reg[2]};

  assign Q = L ? r_in : q_reg[2];

endmodule