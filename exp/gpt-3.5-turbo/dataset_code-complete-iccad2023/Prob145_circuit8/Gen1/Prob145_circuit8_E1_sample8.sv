module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg p_prev;

always @(posedge clock) begin
  p <= clock & a;
  if (p && !p_prev)
    q <= 1;
  else if (!clock)
    q <= 0;
  p_prev <= p;
end

endmodule