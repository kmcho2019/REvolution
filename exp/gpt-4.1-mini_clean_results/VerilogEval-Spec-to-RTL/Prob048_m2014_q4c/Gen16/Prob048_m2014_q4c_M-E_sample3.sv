module TopModule(
  input clk,
  input d,
  input r,
  output reg q
);

  wire enable = ~r;

  always @(posedge clk) begin
    if (r)
      q <= 1'b0;
  end

  always @(posedge clk) begin
    if (enable)
      q <= d;
  end

endmodule