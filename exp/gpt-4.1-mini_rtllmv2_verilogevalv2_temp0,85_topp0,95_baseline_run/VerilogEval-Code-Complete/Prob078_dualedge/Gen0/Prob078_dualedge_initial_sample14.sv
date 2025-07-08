module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_pos, q_neg;

  // Flip-flop triggered on rising edge
  always @(posedge clk) begin
    q_pos <= d;
  end

  // Flip-flop triggered on falling edge
  always @(negedge clk) begin
    q_neg <= d;
  end

  // Multiplexer selects output based on clock level
  always @(*) begin
    if (clk)
      q = q_pos;
    else
      q = q_neg;
  end

endmodule