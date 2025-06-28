module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg q_delay;

always @(posedge clock) begin
  if (a == 1 && q_delay == 0)
    q <= 1;
  else if (a == 0 && q_delay == 1)
    q <= 0;
  
  p <= a;
  q_delay <= a;
end

endmodule