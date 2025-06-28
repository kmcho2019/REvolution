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
  else if (!a && q_next)
    p <= 0;
end

always @(*) begin
  q_next = a;
end

always @(posedge clock) begin
  q <= q_next;
end

endmodule