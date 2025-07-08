module TopModule (
  input clk,
  input d,
  output reg q
);

  reg d_pos, d_neg;
  reg toggle;

  // Sample d on positive edge
  always @(posedge clk) begin
    d_pos <= d;
    toggle <= 1'b1;
  end

  // Sample d on negative edge
  always @(negedge clk) begin
    d_neg <= d;
    toggle <= 1'b0;
  end

  // Update q on both edges depending on toggle
  always @(posedge clk or negedge clk) begin
    if (toggle)
      q <= d_pos;
    else
      q <= d_neg;
  end

endmodule