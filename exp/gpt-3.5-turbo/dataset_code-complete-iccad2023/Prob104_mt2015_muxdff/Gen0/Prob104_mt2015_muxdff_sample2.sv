module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg Q_reg;
  wire mux_out;

  always @(posedge clk) begin
    if (L) begin
      Q_reg <= r_in;
    end else begin
      Q_reg <= mux_out;
    end
  end

  assign mux_out = (L) ? r_in : {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
  assign Q = Q_reg;

endmodule