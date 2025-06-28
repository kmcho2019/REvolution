module TopModule (
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] s,
  output reg overflow
);

always @* begin
  s = a + b; // add two 8-bit two's complement numbers

  // Detect overflow
  if ((a[7] == b[7]) && (a[7] != s[7])) begin
    overflow = 1;
  end
  else begin
    overflow = 0;
  end
end

endmodule