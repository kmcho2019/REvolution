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

// Define the states of the state machine
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;

// Define the direction the Lemming was walking before it fell
reg direction;

always @(*) begin
    // Initialize the next state to the current state
    next_state = state;

    // Initialize the outputs
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            // If the Lemming is bumped on the left, switch to walking right
            if (bump_left) next_state = WALK_RIGHT;
            // If the Lemming is bumped on the right, switch to walking right
            else if (bump_right) next_state = WALK_LEFT;
            // If the ground disappears, start falling
            else if (!ground) next_state = FALLING;
            // If the Lemming is told to dig, start digging
            else if (dig) digging = 1;
        end
        WALK_RIGHT: begin
            walk_right = 1;
            // If the Lemming is bumped on the left, switch to walking left
            if (bump_left) next_state = WALK_LEFT;
            // If the Lemming is bumped on the right, switch to walking left
            else if (bump_right) next_state = WALK_LEFT;
            // If the ground disappears, start falling
            else if (!ground) next_state = FALLING;
            // If the Lemming is told to dig, start digging
            else if (dig) digging = 1;
        end
        FALLING: begin
            aaah = 1;
            // If the ground reappears, stop falling and resume walking in the same direction
            if (ground) begin
                if (direction) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 1;
    end
    else begin
        state <= next_state;
        // Store the direction the Lemming was walking before it fell
        if (state == WALK_LEFT) direction <= 1;
        else if (state == WALK_RIGHT) direction <= 0;
    end
end
endmodule