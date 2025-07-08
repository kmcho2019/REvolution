module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_pos, q_neg;

  // Capture input on positive edge
  always @(posedge clk) begin
    q_pos <= d;
    q <= q_pos;
  end

  // Capture input on negative edge
  always @(negedge clk) begin
    q_neg <= d;
    q <= q_neg;
  end

endmodule