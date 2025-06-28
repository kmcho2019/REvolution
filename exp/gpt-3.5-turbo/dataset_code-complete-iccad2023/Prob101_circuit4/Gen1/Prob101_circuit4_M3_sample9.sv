module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

always @* begin
  if (d == 1 || (b == 1 && c == 1 && a == 0)) begin
    q = 1;
  end
  else begin
    q = 0;
  end
end

endmodule