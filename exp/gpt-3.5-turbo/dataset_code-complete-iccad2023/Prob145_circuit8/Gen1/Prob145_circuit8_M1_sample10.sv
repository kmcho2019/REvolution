module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg q_next;

always @(posedge clock) begin
  if (a)
    p <= 1;
  if (q_next)
    p <= 0;
end

always @(posedge clock) begin
  if (clock) begin
    if (a)
      q_next <= 1;
  end else begin
    q_next <= 0;
  end
end

always @(posedge clock) begin
  q <= q_next;
end

endmodule