module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @* begin
  out = (a & b) | (a & c) | (b & c) | (c & d) | (a & ~b & ~c) | (~a & c & d);
end

endmodule