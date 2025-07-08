module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // State encoding: 0 = walk_left, 1 = walk_right
  reg state;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= 1'b0; // walk_left on reset
    else begin
      // If bumped on either side, toggle direction
      if (bump_left | bump_right)
        state <= ~state;
      else
        state <= state;
    end
  end

  // Outputs depend only on state (Moore machine)
  assign walk_left = (state == 1'b0);
  assign walk_right = (state == 1'b1);

endmodule