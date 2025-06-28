module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
  if ((a & b & c) || (a & b & d) || (a & c & d) || (b & c & d) || (c & d))
    q = 1;
  else
    q = 0;
end

endmodule