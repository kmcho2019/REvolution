module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @* begin
  out = (c && !d && !a && b) || (!c && d && a && !b);
end

endmodule