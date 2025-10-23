module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Assign the outputs based on the current state
always_comb begin
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

// Determine the next state based on the current state and the inputs
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
            else if (bump_left || (bump_left && bump_right)) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig && ground) next_state = DIGGING;
            else if (bump_right || (bump_left && bump_right)) next_state = WALK_LEFT;
            else if (bump_left) next_state = WALK_RIGHT;
        end
        FALLING: begin
            if (ground) next_state = (state == DIGGING) ? WALK_LEFT : ((state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT);
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
    endcase
end

// Update the state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

endmodule