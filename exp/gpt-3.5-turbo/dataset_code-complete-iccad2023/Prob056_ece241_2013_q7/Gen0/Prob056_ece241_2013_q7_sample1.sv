module TopModule (
  input clk,
  input j,
  input k,
  output reg Q
);

reg Q_old;

always @(posedge clk) begin
  if (j & ~k)
    Q <= 1;
  else if (~j & k)
    Q <= 0;
  else if (j & k)
    Q <= ~Q_old;
end

always @(posedge clk) begin
  Q_old <= Q;
end

endmodule