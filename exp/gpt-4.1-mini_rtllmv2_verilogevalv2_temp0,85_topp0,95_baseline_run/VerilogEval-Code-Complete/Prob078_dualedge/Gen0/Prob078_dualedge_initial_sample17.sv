module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_posedge;
  reg q_negedge;

  // Flip-flop triggered on rising edge
  always @(posedge clk) begin
    q_posedge <= d;
  end

  // Flip-flop triggered on falling edge
  always @(negedge clk) begin
    q_negedge <= d;
  end

  // MUX to select output based on clock level
  always @(*) begin
    if (clk)
      q = q_negedge;
    else
      q = q_posedge;
  end

endmodule