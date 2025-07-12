module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output Q
);

  reg q;
  assign Q = q;

  always @(posedge clk) begin
    if (L) begin
      q <= r_in;
    end else begin
      q <= q_in;
    end
  end

endmodule