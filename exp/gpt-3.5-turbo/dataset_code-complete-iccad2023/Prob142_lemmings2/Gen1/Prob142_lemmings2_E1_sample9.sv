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

  // State definition
  parameter WALK_LEFT = 2'd0;
  parameter WALK_RIGHT = 2'd1;
  parameter FALLING = 2'd2;
  parameter BUMPED_FALLING = 2'd3;

  reg [1:0] state, next_state;

  // Mealy state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always @ (*) begin
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
      WALK_LEFT: begin
        // State transitions
        if (bump_right) begin
          next_state = WALK_RIGHT;
        end
        else if (!ground) begin
          next_state = FALLING;
          aaah = 1'b1;
        end
        else begin
          next_state = WALK_LEFT;
          walk_left = 1'b1;
        end
      end
      WALK_RIGHT: begin
        // State transitions
        if (bump_left) begin
          next_state = WALK_LEFT;
        end
        else if (!ground) begin
          next_state = FALLING;
          aaah = 1'b1;
        end
        else begin
          next_state = WALK_RIGHT;
          walk_right = 1'b1;
        end
      end
      FALLING: begin
        // State transitions
        if (ground) begin
          if (state == WALK_LEFT) begin
            next_state = WALK_LEFT;  // Resume walking left
          end
          else begin
            next_state = WALK_RIGHT;  // Resume walking right
          end
        end
        else begin
          next_state = FALLING;
        end
      end
      BUMPED_FALLING: begin
        // State transitions
        if (ground && state == WALK_LEFT) begin
          next_state = WALK_LEFT;  // Resume walking left after bump
        end
        else if (ground && state == WALK_RIGHT) begin
          next_state = WALK_RIGHT;  // Resume walking right after bump
        end
        else begin
          next_state = BUMPED_FALLING;
        end
      end
    endcase
  end

endmodule