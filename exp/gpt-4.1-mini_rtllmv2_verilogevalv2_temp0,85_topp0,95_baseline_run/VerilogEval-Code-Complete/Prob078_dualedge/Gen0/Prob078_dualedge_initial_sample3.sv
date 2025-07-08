module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_pos, q_neg;

  // Sample input on positive edge
  always @(posedge clk) begin
    q_pos <= d;
  end

  // Sample input on negative edge
  always @(negedge clk) begin
    q_neg <= d;
  end

  // Output muxed between q_pos and q_neg depending on clk level
  always @(*) begin
    if (clk)
      q = q_pos;
    else
      q = q_neg;
  end

endmodule