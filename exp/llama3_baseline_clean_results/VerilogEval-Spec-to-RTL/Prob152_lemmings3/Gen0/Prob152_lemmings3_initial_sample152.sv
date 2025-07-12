module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (!ground) next_state = FALLING;
            else if (dig) next_state = DIGGING;
            else if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_LEFT;
        end
        FALLING: begin
            if (ground) next_state = (bump_left || bump_right) ? (state == WALK_LEFT ? WALK_RIGHT : WALK_LEFT) : (state == WALK_LEFT || state == DIGGING) ? WALK_LEFT : WALK_RIGHT;
        end
        DIGGING: begin
            if (!ground) next_state = FALLING;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

// Output logic
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
        default: ;
    endcase
end

endmodule