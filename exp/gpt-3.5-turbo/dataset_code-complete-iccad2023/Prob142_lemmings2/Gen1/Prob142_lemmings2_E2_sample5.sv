module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg aaah
);
  reg direction;

  // Moore state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      direction <= 1'b0; // Initialize to walk_left on reset
      walk_left <= 1'b1;
      aaah <= 1'b0;
    end
    else begin
      if (bump_left) begin
        direction <= 1'b1; // Switch to walk_right if bumped on the left
      end
      else if (bump_right) begin
        direction <= 1'b0; // Switch to walk_left if bumped on the right
      end
      else if (!ground) begin
        aaah <= 1'b1; // Fall and say "aaah!" when ground=0
      end

      // Determine walking direction based on the current state
      if (direction == 1'b0) begin
        walk_left <= 1'b1;
      end
      else begin
        walk_left <= 1'b0;
      end
    end
  end
endmodule