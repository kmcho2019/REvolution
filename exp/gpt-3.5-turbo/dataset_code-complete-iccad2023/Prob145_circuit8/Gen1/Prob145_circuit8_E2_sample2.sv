module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg p_latch, q_latch;

always @(posedge clock) begin
  // State transitions for p and q
  p_latch <= a;
  q_latch <= p;
end

always @(*) begin
  // Output assignment
  if (p_latch && !p) begin
    p <= 1;
  end else if (!p_latch && p) begin
    p <= 0;
  end

  if (q_latch && !q) begin
    q <= 1;
  end else if (!q_latch && q) begin
    q <= 0;
  end
end

endmodule