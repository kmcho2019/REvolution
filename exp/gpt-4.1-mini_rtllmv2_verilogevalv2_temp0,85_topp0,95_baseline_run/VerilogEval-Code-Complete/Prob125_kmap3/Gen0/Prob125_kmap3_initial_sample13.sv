module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);
  always @(*) begin
    out = (c & (b | ~a)) | (~c & ~d & (a | b));
  end
endmodule