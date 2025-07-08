module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  // On rising edge of clock, p follows input a
  always @(posedge clock) begin
    p <= a;
  end

  // On falling edge of clock, q follows p
  always @(negedge clock) begin
    q <= p;
  end

endmodule