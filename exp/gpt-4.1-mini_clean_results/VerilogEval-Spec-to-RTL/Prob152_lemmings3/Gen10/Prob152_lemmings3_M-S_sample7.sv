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

// Define states: combine mode and direction explicitly
typedef enum logic [3:0] {
    WALK_LEFT  = 4'd0,
    WALK_RIGHT = 4'd1,
    FALL_LEFT  = 4'd2,
    FALL_RIGHT = 4'd3,
    DIG_LEFT   = 4'd4,
    DIG_RIGHT  = 4'd5
} state_t;

state_t state, next_state;

// State update
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    // Default hold current state
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
            else if (dig)
                next_state = DIG_LEFT;
            else if (bump_left || bump_right) begin
                // If bumped on left or right (or both), switch direction
                next_state = WALK_RIGHT;
            end
        end

        WALK_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else if (dig)
                next_state = DIG_RIGHT;
            else if (bump_left || bump_right) begin
                // Switch direction on any bump
                next_state = WALK_LEFT;
            end
        end

        FALL_LEFT: begin
            if (ground)
                next_state = WALK_LEFT;
        end

        FALL_RIGHT: begin
            if (ground)
                next_state = WALK_RIGHT;
        end

        DIG_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
        end

        DIG_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
        end

        default: next_state = WALK_LEFT;
    endcase
end

// Output assignments
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule