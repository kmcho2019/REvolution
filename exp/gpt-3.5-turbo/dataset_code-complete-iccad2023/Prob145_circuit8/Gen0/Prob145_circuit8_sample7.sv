module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);
  
reg p_next, q_next; 

always @(posedge clock or negedge a) begin
  if (a) begin
    p_next <= a;
  end else begin
    p_next <= 0;
  end
  q_next <= (a) ? 0 : p;
end

always @(posedge clock) begin
  p <= p_next;
  q <= q_next;
end

endmodule