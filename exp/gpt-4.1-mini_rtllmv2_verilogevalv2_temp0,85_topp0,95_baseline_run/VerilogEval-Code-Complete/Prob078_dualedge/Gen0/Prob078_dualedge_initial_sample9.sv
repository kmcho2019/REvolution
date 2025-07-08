module TopModule (
  input clk,
  input d,
  output reg q
);

  reg q_pos;
  reg q_neg;
  reg q_next;

  // Flip-flop triggered on positive edge
  always @(posedge clk) begin
    q_pos <= d;
  end

  // Flip-flop triggered on negative edge
  always @(negedge clk) begin
    q_neg <= d;
  end

  // Combinational mux selecting output from q_pos or q_neg based on clock level
  always @(*) begin
    if (clk)
      q_next = q_pos;
    else
      q_next = q_neg;
  end

  // Register the final output on posedge clk
  always @(posedge clk) begin
    q <= q_next;
  end

endmodule