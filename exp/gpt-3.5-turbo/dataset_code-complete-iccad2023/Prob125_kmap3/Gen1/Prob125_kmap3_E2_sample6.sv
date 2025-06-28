module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    if (!c && !d) // c=0 and d=0
      out = 1;
    else if (!c && d) // c=0 and d=1
      out = b;
    else if (c) // c=1
      out = 1;
    else // Default case for any other scenarios
      out = 0;
  end

endmodule