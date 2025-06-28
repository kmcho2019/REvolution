module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    if (c & ~d) out = 0;
    else if (~a & (b | c)) out = 1;
    else out = 1;
  end

endmodule