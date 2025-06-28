module TopModule (
  input clk,
  input j,
  input k,
  output reg Q
);

reg Qold;

always @(posedge clk) begin
  if (j & k) begin
    Q <= ~Qold;
  end else if (j) begin
    Q <= 1;
  end else if (k) begin
    Q <= 0;
  end else begin
    Q <= Qold;
  end
end

endmodule