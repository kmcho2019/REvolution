module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
  if ((a & b & c) | (a & b & d) | (a & c & d) | (b & c & d)) begin
    q = 1;
  end
  else begin
    q = 0;
  end
end

endmodule