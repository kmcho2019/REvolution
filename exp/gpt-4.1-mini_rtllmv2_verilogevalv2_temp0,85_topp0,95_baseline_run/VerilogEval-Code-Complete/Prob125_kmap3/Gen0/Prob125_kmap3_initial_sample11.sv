module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

always @(*) begin
  // Simplified expression derived from K-map:
  // out = (~b & c) | (a & ~d) | (b & ~c) | (a & b)
  out = ((!b) & c) | (a & (!d)) | (b & (!c)) | (a & b);
end

endmodule