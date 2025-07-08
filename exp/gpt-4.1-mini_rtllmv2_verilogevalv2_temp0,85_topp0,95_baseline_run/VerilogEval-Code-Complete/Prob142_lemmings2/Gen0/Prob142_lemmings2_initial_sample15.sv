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

  // State encoding
  localparam WALK_LEFT  = 2'b00;
  localparam WALK_RIGHT = 2'b01;
  localparam FALLING    = 2'b10;

  reg [1:0] state, next_state;
  reg walk_dir_before_fall; // 0 = left, 1 = right

  // State register with async posedge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir_before_fall <= 1'b0; // walking left on reset
    end else begin
      state <= next_state;
      // Update walk_dir_before_fall when entering FALLING state
      if (state != FALLING && next_state == FALLING) begin
        // Save walking direction before falling
        if (state == WALK_LEFT)
          walk_dir_before_fall <= 1'b0;
        else if (state == WALK_RIGHT)
          walk_dir_before_fall <= 1'b1;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      WALK_LEFT: begin
        if (!ground) // ground disappeared, start falling
          next_state = FALLING;
        else if (bump_left || bump_right) // bump causes direction change
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (!ground)
          next_state = FALLING;
        else if (bump_left || bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end
      FALLING: begin
        if (ground) begin
          // ground returned, resume walking in previous direction
          if (walk_dir_before_fall == 1'b0)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end else
          next_state = FALLING;
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule