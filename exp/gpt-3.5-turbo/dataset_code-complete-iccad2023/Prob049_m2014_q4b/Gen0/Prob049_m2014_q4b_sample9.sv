module d_ff_posedge_async_reset (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or negedge ar)
begin
  if (!ar)
    q <= 1'b0;
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

reg q;
    
d_ff_posedge_async_reset d_ff (
  .clk(clk),
  .d(d),
  .ar(ar),
  .q(q)
);

endmodule