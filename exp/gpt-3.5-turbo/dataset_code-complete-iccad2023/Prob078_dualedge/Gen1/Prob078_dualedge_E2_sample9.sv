module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_temp;
reg q_last;
reg flip_flop_trigger;

always @(posedge clk or negedge clk)
begin
  // Detect rising and falling edges of the clock
  if (~flip_flop_trigger && (posedge clk && (~q_last || d))
     || (~flip_flop_trigger && (negedge clk && (q_last || d)))
     || (flip_flop_trigger && (posedge clk || negedge clk)))
  begin
    q_temp <= d;
    flip_flop_trigger <= ~flip_flop_trigger;
  end
end

always @*
begin
  // Update the output based on stored input value
  q_last <= q_temp;
  q <= q_temp;
end

endmodule