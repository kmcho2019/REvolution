module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg internal_Q;
  reg next_Q;

  always @(*) begin
    if (L) begin
      next_Q = r_in;
    end else begin
      next_Q = q_in;
    end
  end

  always @(posedge clk) begin
    internal_Q <= next_Q;
  end

  assign Q = internal_Q;

endmodule