module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    if ((c & !d) || (!c & d)) // cd is 00 or 11
      out = 1;
    else // cd is 01
      out = 0;
  end

endmodule