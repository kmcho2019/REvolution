module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);
  reg p_next;

  always @(posedge clock) begin
    p <= a;
    q <= p;
  end
endmodule