module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_posedge, q_negedge;

  // Flip-flop triggered on positive edge of clk
  always @(posedge clk) begin
    q_posedge <= d;
  end

  // Flip-flop triggered on negative edge of clk
  always @(negedge clk) begin
    q_negedge <= d;
  end

  // Multiplexer selects output based on clock level
  always @(*) begin
    if (clk)
      q = q_posedge;
    else
      q = q_negedge;
  end

endmodule