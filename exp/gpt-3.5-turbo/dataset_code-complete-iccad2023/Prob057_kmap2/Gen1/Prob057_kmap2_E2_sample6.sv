module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @* begin
  out = (b & c) | (~a & c) | (a & b & ~d);
end

endmodule