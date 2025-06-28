module DFF_async_reset (
  input clk,
  input d,
  input ar,
  output reg q
);

always @ (posedge clk or negedge ar)
begin
  if (~ar) // Asynchronous reset
    q <= 1'b0;
  else // Positive edge-triggered D flip flop
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input d,
  input ar,
  output logic q
);

DFF_async_reset dff_inst (
  .clk(clk),
  .d(d),
  .ar(ar),
  .q(q)
);

endmodule