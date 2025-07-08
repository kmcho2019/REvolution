module TopModule (
  input clk,
  input d,
  output reg q
);

  reg d_pos, d_neg;

  // Capture d on positive edge
  always @(posedge clk) begin
    d_pos <= d;
  end

  // Capture d on negative edge
  always @(negedge clk) begin
    d_neg <= d;
  end

  // Output follows d_pos when clk is high, and d_neg when clk is low
  always @(*) begin
    if (clk)
      q = d_pos;
    else
      q = d_neg;
  end

endmodule