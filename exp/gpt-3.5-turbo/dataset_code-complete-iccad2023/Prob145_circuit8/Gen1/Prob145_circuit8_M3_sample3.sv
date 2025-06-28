module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg last_q;

always @(posedge clock) begin
  if (a)
    p <= 1;
  else if (last_q)
    p <= 0;

  if (a && clock)
    q <= 1;
  else if (!clock)
    last_q <= q;
end

endmodule