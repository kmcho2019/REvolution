module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg prev_a;

always @(posedge clk) begin
  if (a & !prev_a & b) begin
    q <= ~q;
  end
  prev_a <= a;
  state <= (a & b);
end

endmodule