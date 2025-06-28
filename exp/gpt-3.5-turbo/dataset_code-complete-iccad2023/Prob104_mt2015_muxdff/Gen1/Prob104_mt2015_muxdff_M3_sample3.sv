module TopModule (
  input clk,
  input L,
  input [2:0] q_in,
  input [2:0] r_in,
  output reg [2:0] Q
);

  reg [2:0] Q_reg;
  
  always @(posedge clk) begin
    if (L) begin
      Q_reg <= r_in;
    end else begin
      Q_reg <= {Q_reg[1]^Q_reg[2], q_in[0], q_in[2]};
    end
  end

  assign Q = Q_reg;

endmodule