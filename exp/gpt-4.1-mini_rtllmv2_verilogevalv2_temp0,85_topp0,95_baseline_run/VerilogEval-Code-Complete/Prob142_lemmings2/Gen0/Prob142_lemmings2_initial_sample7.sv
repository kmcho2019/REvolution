module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output walk_left,
  output walk_right,
  output aaah
);
  
  // States encoding
  localparam WALK_LEFT  = 2'b00;
  localparam WALK_RIGHT = 2'b01;
  localparam FALLING    = 2'b10;
  
  reg [1:0] state, next_state;
  reg last_dir; // 0 = left, 1 = right, tracks walking direction before falling

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_dir <= 1'b0; // walking left
    end else begin
      state <= next_state;
      // Update last_dir only when walking, to remember direction before falling
      if (next_state == WALK_LEFT)
        last_dir <= 1'b0;
      else if (next_state == WALK_RIGHT)
        last_dir <= 1'b1;
      // Do not update last_dir when falling
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (ground == 0) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // If bumped on left or right (or both), switch direction to right
          // Actually bump_left makes switch to right, bump_right makes switch to left.
          // But problem says if bumped on both sides, still switch direction.
          // If bumped on left, go right; if bumped on right, go left
          // So if bump_left == 1, go right; else if bump_right == 1, go left
          // But if both are 1, still switch direction, so that means both bump => switch direction, which from walking left means walk right.
          // So priority is bump_left => walk right
          // else if bump_right => walk left
          // For walking left, bumped left means switch to right (walk right)
          // bumped right means switch to left (which is current state), so no change? But problem says switch direction when bumped right, so walking left bumped right => walk left or right?
          // Actually problem says: 
          // "if bumped on left, walk right"
          // "if bumped on right, walk left"
          // "if bumped both, still switch directions"
          // So for walking left (which is facing left), bump_left means bump on left => walk right
          // bump_right means bump on right => walk left
          // So if bump_right is 1 and bump_left is 0, walking left stays walking left? That conflicts with "switch direction if bumped".
          // The problem states: "It will switch directions if it hits an obstacle."
          // bump_left = 1 => walk right
          // bump_right = 1 => walk left
          // Both bump => switch directions
          // So any bump flips direction.
          // So walking left bumped left or right or both => walk right
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // Walking right bumped either side => switch direction to left
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALLING: begin
        if (ground == 1) begin
          // ground reappears, resume walking in last_dir direction
          if (last_dir == 1'b0)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore machine)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule