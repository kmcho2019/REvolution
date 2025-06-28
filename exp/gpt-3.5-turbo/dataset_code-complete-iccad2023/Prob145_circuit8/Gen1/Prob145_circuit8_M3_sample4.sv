module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

always @(posedge clock) begin
  if (a)
    p <= 1;
  else if (q)
    p <= 0;

  if (a && (posedge clock)) 
    q <= 1;
  else if (!clock)
    q <= 0;
end

endmodule