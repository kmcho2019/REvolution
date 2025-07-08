module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @(*) begin
  out = c | (a & ~c & ~d);
end

endmodule