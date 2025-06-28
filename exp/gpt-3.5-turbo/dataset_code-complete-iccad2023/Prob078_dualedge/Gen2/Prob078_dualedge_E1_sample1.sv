module TopModule (
  input clk,
  input d,
  output reg q
);

reg l1, l2, q_temp;

always @(*) begin
  if (clk) begin
    l1 <= d;
  end
end

always @(*) begin
  if (!clk) begin
    l2 <= l1;
  end
end

always @(posedge clk) begin
  q_temp <= l2;
end

always @(posedge clk) begin
  q <= q_temp;
end

endmodule