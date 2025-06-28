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

// Enum representing the possible states for Lemming tasks
typedef enum logic [3:0] {
    WALKING,
    FALLING,
    DIGGING
} task_state_t;

// Enum representing the possible walking directions
typedef enum logic [1:0] {
    LEFT,
    RIGHT
} direction_t;

// State variables for Lemming tasks
reg [3:0] state, next_state;
reg [1:0] direction;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING; // Reset to initial state (walking)
        direction <= LEFT; // Start by walking left
    end else begin
        state <= next_state; // Update state based on next_state
    end
end

always @* begin
    next_state = state;
    aaah = 0;
    digging = 0;

    case (state)
        WALKING: begin
            walk_left = (direction == LEFT);
            walk_right = (direction == RIGHT);
            if (bump_left) direction = RIGHT;
            else if (bump_right) direction = LEFT;
            else if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
        end
        FALLING: begin
            walk_left = (direction == LEFT);
            walk_right = (direction == RIGHT);
            aaah = 1;
            if (ground) next_state = WALKING;
        end
        DIGGING: begin
            walk_left = (direction == LEFT);
            walk_right = (direction == RIGHT);
            digging = 1;
            if (!ground) next_state = FALLING;
        end
    endcase
end

endmodule