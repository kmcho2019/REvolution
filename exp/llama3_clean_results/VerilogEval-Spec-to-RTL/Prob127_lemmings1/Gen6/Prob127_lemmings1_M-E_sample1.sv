module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg state;

always_latch begin
  if (areset) begin
    state <= 0; // Initialize state to LEFT (0)
  end else if (clk) begin
    case ({bump_left, bump_right})
      2'b01: state <= 1; // LEFT state and bump_left is high, switch to RIGHT
      2'b10: state <= 0; // RIGHT state and bump_right is high, switch to LEFT
      2'b11: state <= ~state; // Both bump_left and bump_right are high, switch state
      default: state <= state; // No change in state
    endcase
  end
end

assign walk_left = ~state; // LEFT state
assign walk_right = state; // RIGHT state

endmodule