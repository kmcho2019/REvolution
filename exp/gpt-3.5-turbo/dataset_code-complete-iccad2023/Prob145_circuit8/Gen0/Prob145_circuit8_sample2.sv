module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg p_next, q_next;

always @(posedge clock) begin
  // Logic for updating p and q
  if (a == 1 && !p) begin
    p_next = 1;
  end else begin
    p_next = 0;
  end

  if (p && !q) begin
    q_next = 1;
  end else begin
    q_next = 0;
  end
end

always @(posedge clock or negedge clock) begin
  // Synchronous reset
  if (!clock) begin
    p <= 0;
    q <= 0;
  end else begin
    p <= p_next;
    q <= q_next;
  end
end

endmodule