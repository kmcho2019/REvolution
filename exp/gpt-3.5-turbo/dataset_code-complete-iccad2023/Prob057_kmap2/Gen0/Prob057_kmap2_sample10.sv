module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @* begin
  out = (~a & ~b & c) | (~a & b & ~d) | (b & c) | (a & ~b & d);
end

endmodule