module TopModule (
  input clk,
  input d,
  output reg q
);

reg d_neg;

always @(posedge clk) begin
  d_neg <= ~d;
end

always @(posedge clk) begin
  if ($past(clk)) begin
    q <= d_neg;
  end
  else begin
    q <= d;
  end
end

endmodule