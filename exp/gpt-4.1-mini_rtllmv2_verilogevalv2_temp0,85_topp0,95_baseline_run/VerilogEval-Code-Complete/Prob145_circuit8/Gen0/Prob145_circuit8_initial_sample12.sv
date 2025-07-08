module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg p_next;

  // p is updated on rising edge: p = a & ~p (pulse generation when a=1 and p=0)
  always @(posedge clock) begin
    if (a && !p)
      p <= 1;
    else
      p <= 0;
  end

  // q follows p sampled on falling edge of clock
  always @(negedge clock) begin
    q <= p;
  end

endmodule