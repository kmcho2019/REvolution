module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] gray_next;
reg [1:0] gray_curr;

always @(posedge clk) begin
  gray_next[0] <= a ^ b;
  gray_next[1] <= a;
  gray_curr <= gray_next;
end

always @* begin
  q = gray_curr[1];
  state = gray_curr[0];
end

endmodule