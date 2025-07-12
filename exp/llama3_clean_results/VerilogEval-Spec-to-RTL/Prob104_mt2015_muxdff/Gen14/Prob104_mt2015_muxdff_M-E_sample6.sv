module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg q_prev;

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      Q <= q_in ^ q_prev;
      q_prev <= Q;
    end
  end

endmodule