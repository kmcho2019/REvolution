module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    if (c == 0)
      out = 1;
    else
      out = a;
  end

endmodule