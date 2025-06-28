module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg q_reg;

  always @(posedge clk) begin
    if (L) begin
      q_reg <= r_in;
    end else begin
      q_reg <= {q_reg[1] ^ q_reg[2], q_reg[0], q_reg[2]};
    end
  end

  assign Q = L ? r_in : q_reg;

endmodule