module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
    if (d || (a & b) || (b & c) || (a & c))
        q = 1;
    else
        q = 0;
end

endmodule