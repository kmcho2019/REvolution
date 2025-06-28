module TopModule (
  input a,
  input b,
  input c,
  output reg out
);

always @* begin
  if (a) // Output is 1 for a=1
    out = 1;
  else
    out = (b | c); // Output is 1 for b=1 or c=1 when a=0
end

endmodule