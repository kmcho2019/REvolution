module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg next_Q;

  always @(*) begin
    if (L) begin
      next_Q = r_in;
    end else begin
      next_Q = q_in ^ Q;
    end
  end

  always @(posedge clk) begin
    Q <= next_Q;
  end

endmodule