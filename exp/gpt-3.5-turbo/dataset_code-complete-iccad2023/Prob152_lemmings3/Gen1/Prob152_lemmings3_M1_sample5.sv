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
    DIGGING
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
            if (dig && ground) next_state = DIGGING;
            else if (!ground) next_state = FALLING;
            else if (bump_right) next_state = WALK_RIGHT;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = ground ? 0 : 1;
            digging = 0;
            if (dig && ground) next_state = DIGGING;
            else if (!ground) next_state = FALLING;
            else if (bump_left) next_state = WALK_LEFT;
        end
        FALLING: begin
            walk_left = (state == WALK_LEFT);
            walk_right = (state == WALK_RIGHT);
            aaah = 1;
            digging = 0;
            if (ground) next_state = walk_left ? WALK_LEFT : WALK_RIGHT;
        end
        DIGGING: begin
            walk_left = (state == WALK_LEFT);
            walk_right = (state == WALK_RIGHT);
            aaah = ground ? 0 : 1;
            digging = 1;
            if (!ground) next_state = FALLING;
            else if (dig && ground) next_state = state; // Stay in DIGGING state
            else next_state = walk_left ? WALK_LEFT : WALK_RIGHT;
        end
    endcase
end

endmodule