module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_rising, q_falling;

  // Capture input d on rising edge
  always @(posedge clk) begin
    q_rising <= d;
  end

  // Capture input d on falling edge
  always @(negedge clk) begin
    q_falling <= d;
  end

  // Multiplex output depending on clock level
  always @(*) begin
    if (clk)
      q = q_rising;
    else
      q = q_falling;
  end

endmodule