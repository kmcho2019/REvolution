module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg Q_temp;

  always @ (posedge clk) begin
    if (L) begin
      Q_temp <= r_in;
    end else begin
      Q_temp <= {Q_temp[1] ^ Q_temp[2], Q_temp[0], Q_temp[2]};
    end
  end

  assign Q = L ? r_in : Q_temp[2:0];

endmodule