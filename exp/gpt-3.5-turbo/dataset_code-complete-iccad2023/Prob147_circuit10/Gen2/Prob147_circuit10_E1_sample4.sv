module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  if (a & ~b) // Transition condition: a rising edge while b is 1
    next_state <= ~state;
  else
    next_state <= state;

  state <= next_state;
  q <= state;
end

endmodule