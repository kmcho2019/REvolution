module DFF_async_reset (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or posedge ar)
begin
  if (ar)
    q <= 1'b0;
  else if (clk)
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