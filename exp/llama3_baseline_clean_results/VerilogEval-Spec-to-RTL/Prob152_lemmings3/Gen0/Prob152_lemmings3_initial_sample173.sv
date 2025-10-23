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

// Define the states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Define the initial state
initial state = WALK_LEFT;

// Reset the state machine on asynchronous reset
always @(posedge areset) state = WALK_LEFT;

// Define the state transitions
always @(*) begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT; // No change
        end
        WALK_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_LEFT; // No change
        end
        FALLING: begin
            if (ground) next_state = WALK_LEFT; // Resumes walking left
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
    endcase
end

// Update the state on positive edge of the clock
always @(posedge clk) state = next_state;

// Define the output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        WALK_LEFT: walk_left = 1;
        WALK_RIGHT: walk_right = 1;
        FALLING: aaah = 1;
        DIGGING: digging = 1;
    endcase
end

endmodule