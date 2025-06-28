module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

  reg direction; // 1-bit flip-flop to store Lemming's current direction (0 for left, 1 for right)

  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      direction <= 1'b0; // Reset Lemming to walk left
    end
    else begin
      // Switch direction based on bumps, remain in the same direction when falling
      if (bump_right && !bump_left) begin
        direction <= 1'b1; // Walk right
      end
      else if (bump_left && !bump_right) begin
        direction <= 1'b0; // Walk left
      end
    end
  end

  always @ (*) begin
    walk_left = direction == 1'b0 && ground; // Lemming walks left when direction is 0 and on ground
    walk_right = direction == 1'b1 && ground; // Lemming walks right when direction is 1 and on ground
    aaah = !ground; // Lemming says "aaah!" when falling (ground=0)
  end

endmodule