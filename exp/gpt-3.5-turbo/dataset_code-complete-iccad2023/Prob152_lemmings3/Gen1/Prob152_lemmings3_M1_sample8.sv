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
    FALL,
    DIGGING
} state_t;

// State and next state variables
reg [3:0] state, next_state;
reg falling, digging;

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
            if (bump_right) next_state = WALK_RIGHT;
            else if (dig && ground) next_state = DIGGING;
            else if (!ground) next_state = FALLING;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            if (bump_left) next_state = WALK_LEFT;
            else if (dig && ground) next_state = DIGGING;
            else if (!ground) next_state = FALLING;
        end
        FALLING: begin
            walk_left = falling ? state == WALK_LEFT : 0;
            walk_right = falling ? state == WALK_RIGHT : 0;
            falling = 1;
            next_state = ground ? FALL : FALLING;
        end
        FALL: begin
            walk_left = falling ? state == WALK_LEFT : 0;
            walk_right = falling ? state == WALK_RIGHT : 0;
            aaah = 0;
            falling = 0;
            next_state = state;
        end
        DIGGING: begin
            walk_left = digging ? walk_left : 0;
            walk_right = digging ? walk_right : 0;
            digging = 1;
            next_state = ground ? state : FALLING;
        end
    endcase
end

endmodule