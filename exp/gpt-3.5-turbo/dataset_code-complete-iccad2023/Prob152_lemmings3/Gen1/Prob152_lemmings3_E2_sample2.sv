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
typedef enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    FALL_THEN_WALK
} state_t;

// State and next state variables
reg [3:0] state, next_state;

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
            if (bump_right) next_state = WALK_RIGHT;
            else if (!ground && !dig) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = ground ? 0 : 1;
            digging = 0;
            if (bump_left) next_state = WALK_LEFT;
            else if (!ground && !dig) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
            next_state = ground ? FALL_THEN_WALK : FALLING;
        end
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = ground ? 0 : 1;
            digging = 1;
            next_state = ground ? DIGGING : FALLING;
        end
        FALL_THEN_WALK: begin
            walk_left = state == WALK_LEFT ? 1 : 0;
            walk_right = state == WALK_LEFT ? 0 : 1;
            aaah = 0;
            digging = 0;
            if (!ground) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
            else if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_RIGHT;
        end
    endcase
end

endmodule