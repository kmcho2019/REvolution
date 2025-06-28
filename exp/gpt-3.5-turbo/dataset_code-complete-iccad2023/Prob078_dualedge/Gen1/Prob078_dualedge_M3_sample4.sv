module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_prev;

always @(posedge clk or negedge clk) begin
  q <= d ^ q_prev;
  q_prev <= q;
end

endmodule