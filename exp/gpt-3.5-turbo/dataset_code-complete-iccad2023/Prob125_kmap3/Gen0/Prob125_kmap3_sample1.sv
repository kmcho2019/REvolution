module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @(a, b, c, d)
begin
  if (c == 0 && d == 1)
    out <= 1;
  else
    out <= 0; // Output can be anything else when the condition isn't met
end

endmodule