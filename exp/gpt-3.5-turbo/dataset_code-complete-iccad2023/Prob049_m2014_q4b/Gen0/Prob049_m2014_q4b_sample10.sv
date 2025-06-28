module DFF_pos_edge_async_reset (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or posedge ar)
begin
  if(ar)
    q <= 0;
  else
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input d,
  input ar,
  output logic q
);

DFF_pos_edge_async_reset DFF(
  .clk(clk),
  .d(d),
  .ar(ar),
  .q(q)
);

endmodule