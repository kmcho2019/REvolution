module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    if (c == 0 && d == 0)
      out = 1;
    else if (c == 0 && d == 1)
      out = 0;
    else if (c == 1 && d == 0)
      out = a;
    else
      out = 1;
  end

endmodule