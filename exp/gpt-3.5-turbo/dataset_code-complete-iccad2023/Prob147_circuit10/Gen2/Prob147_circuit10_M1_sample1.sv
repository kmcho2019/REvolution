module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg prev_a = 1'b0;
reg prev_b = 1'b0;

always @(posedge clk) begin
  if ((a != prev_a) || (b != prev_b)) begin
    state <= ~state;
  end

  q <= state;
  prev_a <= a;
  prev_b <= b;
end

endmodule