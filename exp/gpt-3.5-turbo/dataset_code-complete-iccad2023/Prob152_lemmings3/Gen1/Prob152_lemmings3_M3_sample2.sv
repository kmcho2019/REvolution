module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

// Enum representing the possible states
typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALL_OR_DUGGING,
    FALLING
} state_t;

// State and next state variables
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // Reset to initial state (walking left)
    end else begin
        state <= next_state; // Update state based on next_state
    end
end

always @* begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = ground ? 0 : 1;
            digging = 0;
            next_state = (bump_right) ? WALK_RIGHT :
                         (dig && ground) ? FALL_OR_DUGGING :
                         (!ground) ? FALLING :
                         WALK_LEFT;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = ground ? 0 : 1;
            digging = 0;
            next_state = (bump_left) ? WALK_LEFT :
                         (dig && ground) ? FALL_OR_DUGGING :
                         (!ground) ? FALLING :
                         WALK_RIGHT;
        end
        FALL_OR_DUGGING: begin
            walk_left = state == WALK_LEFT;
            walk_right = state == WALK_RIGHT;
            aaah = 1;
            digging = (dig && ground) ? 1 : 0;
            next_state = (ground && !dig) ? state : FALLING;
        end
        FALLING: begin
            walk_left = state == WALK_LEFT;
            walk_right = state == WALK_RIGHT;
            aaah = 1;
            digging = 0;
            next_state = (ground) ? state : FALLING;
        end
    endcase
end

endmodule