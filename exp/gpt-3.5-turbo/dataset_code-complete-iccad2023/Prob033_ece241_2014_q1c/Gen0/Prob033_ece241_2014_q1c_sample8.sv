module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);

reg [7:0] sum;
reg a_msb, b_msb, s_msb;

always @*
begin
  sum = a + b;
  a_msb = a[7];
  b_msb = b[7];
  s_msb = sum[7];
end

assign s = sum;
assign overflow = (a_msb & b_msb & !s_msb) | (!a_msb & !b_msb & s_msb);

endmodule