module TopModule (
  input clk,
  input L,
  input [2:0] q_in,
  input [2:0] r_in,
  output reg [2:0] Q
);

  reg [2:0] mux_out;
  reg [2:0] Q_reg;

  always @* begin
    mux_out = (L == 1'b1) ? r_in : {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
  end

  always @(posedge clk) begin
    Q_reg <= mux_out;
  end

  assign Q = Q_reg;

endmodule