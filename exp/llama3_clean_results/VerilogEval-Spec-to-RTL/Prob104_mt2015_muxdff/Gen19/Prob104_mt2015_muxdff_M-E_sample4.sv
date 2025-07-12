module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg internal_Q;

  always @(*) begin
    if (L) begin
      internal_Q = r_in;
    end else begin
      internal_Q = q_in;
    end
  end

  always @(posedge clk) begin
    Q <= internal_Q;
  end

endmodule