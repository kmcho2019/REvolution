module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @(*) begin
  out = a | (c & ~a & ~b);
end

endmodule