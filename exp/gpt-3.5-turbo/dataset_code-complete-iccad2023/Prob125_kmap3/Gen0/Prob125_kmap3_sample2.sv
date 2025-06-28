module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @ (*)
begin
  if (c == 0 && d == 0) // cd=00
    out = a;
  else if (c == 0 && d == 1) // cd=01
    out = 0;
  else if (c == 1 && d == 0) // cd=10
    out = b;
  else // cd=11
    out = 1;
end

endmodule