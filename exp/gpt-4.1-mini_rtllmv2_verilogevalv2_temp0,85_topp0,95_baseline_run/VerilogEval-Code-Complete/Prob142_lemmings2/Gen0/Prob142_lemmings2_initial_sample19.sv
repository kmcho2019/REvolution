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

  // State encoding
  typedef enum reg [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10
  } state_t;

  state_t state, next_state;
  state_t prev_walk_dir; // To remember direction during falling

  // Next state logic
  always @(*) begin
    next_state = state;

    case (state)
      WALK_LEFT: begin
        if (ground == 0)
          next_state = FALLING;
        else if ((bump_left || bump_right) && ground == 1)
          next_state = WALK_RIGHT;
      end
      WALK_RIGHT: begin
        if (ground == 0)
          next_state = FALLING;
        else if ((bump_left || bump_right) && ground == 1)
          next_state = WALK_LEFT;
      end
      FALLING: begin
        if (ground == 1) begin
          // Return to previous walking direction
          if (prev_walk_dir == WALK_LEFT)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end
        // else stay in FALLING
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // State and prev_walk_dir update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      prev_walk_dir <= WALK_LEFT;
    end else begin
      // If we enter FALLING, save the current walking direction
      if (state != FALLING && next_state == FALLING) begin
        prev_walk_dir <= state;
      end
      state <= next_state;
    end
  end

  // Output logic (Moore)
  always @(*) begin
    case(state)
      WALK_LEFT: begin
        walk_left = 1;
        walk_right = 0;
        aaah = 0;
      end
      WALK_RIGHT: begin
        walk_left = 0;
        walk_right = 1;
        aaah = 0;
      end
      FALLING: begin
        // During falling, outputs same direction as before but aaah=1
        if (prev_walk_dir == WALK_LEFT) begin
          walk_left = 1;
          walk_right = 0;
        end else begin
          walk_left = 0;
          walk_right = 1;
        end
        aaah = 1;
      end
      default: begin
        walk_left = 1;
        walk_right = 0;
        aaah = 0;
      end
    endcase
  end

endmodule