module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

  // State definition
  typedef enum logic [1:0] {
    WALKING_LEFT,
    WALKING_RIGHT
  } state_type;

  // Register definitions
  reg [1:0] state_reg, state_next;

  // Initialize state
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state_reg <= WALKING_LEFT;
    end
    else begin
      state_reg <= state_next;
    end
  end

  // State logic
  always @* begin
    case (state_reg)
      WALKING_LEFT:
        begin
          walk_left  = 1;
          walk_right = 0;
          if (bump_left)
            state_next = WALKING_RIGHT;
          else
            state_next = WALKING_LEFT;
        end
      WALKING_RIGHT:
        begin
          walk_left  = 0;
          walk_right = 1;
          if (bump_right)
            state_next = WALKING_LEFT;
          else
            state_next = WALKING_RIGHT;
        end
      default:
        state_next = WALKING_LEFT;
    endcase
  end

endmodule