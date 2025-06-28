module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
  q = (d || (a ^ b));
end

endmodule