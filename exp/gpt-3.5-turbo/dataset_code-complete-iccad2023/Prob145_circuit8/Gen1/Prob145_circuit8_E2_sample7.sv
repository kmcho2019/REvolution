module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg q_delay;

always @(posedge clock) begin
  if (a) begin
    p <= 1;
    q <= 1;
  end else if (q_delay) begin
    p <= 0;
    q <= 1;
  end else begin
    q <= 0;
  end
end

always @(posedge clock) begin
  q_delay <= q;
end

endmodule