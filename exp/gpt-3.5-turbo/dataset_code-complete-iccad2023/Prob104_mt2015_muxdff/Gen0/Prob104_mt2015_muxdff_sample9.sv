module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg Q_reg;

  always @(posedge clk) begin
    if (L)
      Q_reg <= r_in;
    else
      Q_reg <= {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
  end

  assign Q = L ? r_in : Q_reg;

endmodule