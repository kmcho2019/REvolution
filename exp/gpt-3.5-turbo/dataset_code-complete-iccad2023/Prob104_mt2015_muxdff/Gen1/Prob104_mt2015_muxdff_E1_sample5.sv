module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg [2:0] Q_reg;
  reg [2:0] mux_output;

  always @(posedge clk) begin
    if (L) begin
      Q_reg <= r_in;
    end else begin
      Q_reg <= {Q_reg[1]^Q_reg[2], r_in, Q_reg[2]};
    end
  end

  always @* begin
    mux_output = L ? r_in : Q_reg;
  end

  assign Q = mux_output;

endmodule