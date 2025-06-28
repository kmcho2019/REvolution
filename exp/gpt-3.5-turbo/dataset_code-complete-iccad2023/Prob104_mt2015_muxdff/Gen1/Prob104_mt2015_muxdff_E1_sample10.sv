module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg Q_temp;
  reg [2:0] D_ff;

  always @ (posedge clk or negedge L) begin
    if (~L) begin
      D_ff <= {D_ff[1] ^ D_ff[2], D_ff[0], D_ff[2]};
    end else begin
      D_ff <= r_in;
    end
  end

  assign Q_temp = L ? r_in : D_ff[2:0];
  assign Q = L ? r_in : Q_temp;

endmodule