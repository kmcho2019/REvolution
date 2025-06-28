module DFF (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or posedge ar)
begin
  if (ar)
    q <= 1'b0;
  else if (posedge clk)
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input d,
  input ar,
  output reg q
);

DFF DFF_INST (
  .clk(clk),
  .d(d),
  .ar(ar),
  .q(q)
);

endmodule