module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg q
);

reg prev_d;

always @(a, b, c, d) begin
  if (d && !prev_d) begin
    q <= ~q;
  end
  prev_d <= d;
end

initial begin
  q <= 1;
  prev_d <= 0;
end

endmodule