module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input feedback,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      Q <= q_in ^ feedback;
    end
  end

endmodule