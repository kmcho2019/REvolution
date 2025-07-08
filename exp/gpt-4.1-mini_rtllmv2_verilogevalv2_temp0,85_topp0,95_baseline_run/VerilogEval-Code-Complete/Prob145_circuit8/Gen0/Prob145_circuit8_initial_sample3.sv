module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

always @(posedge clock) begin
  p <= a;      // p captures a on rising clock edge
  if (q)
    q <= q;    // hold q if already set
  else
    q <= 0;    // reset q on rising edge unless held
end

always @(negedge clock) begin
  q <= p;      // q captures p on falling clock edge
end

endmodule