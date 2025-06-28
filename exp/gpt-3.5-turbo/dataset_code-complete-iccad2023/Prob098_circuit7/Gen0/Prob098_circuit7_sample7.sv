module TopModule (
  input clk,
  input a,
  output reg q
);

reg q_next;

always @(posedge clk) begin
  q <= q_next;
end

always @(a) begin
  q_next <= a;
end

endmodule