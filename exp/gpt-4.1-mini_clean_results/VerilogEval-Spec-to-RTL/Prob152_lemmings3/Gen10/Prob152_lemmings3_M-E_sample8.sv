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

// Define states
typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    DIG_LEFT   = 3'd2,
    DIG_RIGHT  = 3'd3,
    FALL_LEFT  = 3'd4,
    FALL_RIGHT = 3'd5
} state_t;

state_t state, next_state;

// On asynchronous reset, set to WALK_LEFT
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Helper function to toggle walking direction state
function state_t toggle_direction(input state_t s);
    case(s)
        WALK_LEFT:  toggle_direction = WALK_RIGHT;
        WALK_RIGHT: toggle_direction = WALK_LEFT;
        DIG_LEFT:   toggle_direction = DIG_RIGHT;
        DIG_RIGHT:  toggle_direction = DIG_LEFT;
        FALL_LEFT:  toggle_direction = FALL_RIGHT;
        FALL_RIGHT: toggle_direction = FALL_LEFT;
        default:    toggle_direction = WALK_LEFT; // safe default
    endcase
endfunction

// Check if state is walking
function logic is_walking(input state_t s);
    return (s == WALK_LEFT) || (s == WALK_RIGHT);
endfunction

// Check if state is digging
function logic is_digging(input state_t s);
    return (s == DIG_LEFT) || (s == DIG_RIGHT);
endfunction

// Check if state is falling
function logic is_falling(input state_t s);
    return (s == FALL_LEFT) || (s == FALL_RIGHT);
endfunction

// Check if direction is left
function logic direction_is_left(input state_t s);
    return (s == WALK_LEFT) || (s == DIG_LEFT) || (s == FALL_LEFT);
endfunction

always_comb begin
    next_state = state; // default hold

    case (state)
        // Walking left
        WALK_LEFT: begin
            if (ground == 0) begin
                next_state = FALL_LEFT;
            end else if (dig == 1) begin
                next_state = DIG_LEFT;
            end else if (bump_left && bump_right) begin
                // toggle direction
                next_state = WALK_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // remain walking left
            end else begin
                next_state = WALK_LEFT; // no change
            end
        end

        // Walking right
        WALK_RIGHT: begin
            if (ground == 0) begin
                next_state = FALL_RIGHT;
            end else if (dig == 1) begin
                next_state = DIG_RIGHT;
            end else if (bump_left && bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT; // remain right
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        // Digging left
        DIG_LEFT: begin
            if (ground == 0) begin
                next_state = FALL_LEFT;
            end else begin
                next_state = DIG_LEFT; // keep digging
            end
        end

        // Digging right
        DIG_RIGHT: begin
            if (ground == 0) begin
                next_state = FALL_RIGHT;
            end else begin
                next_state = DIG_RIGHT;
            end
        end

        // Falling left
        FALL_LEFT: begin
            if (ground == 1) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = FALL_LEFT;
            end
        end

        // Falling right
        FALL_RIGHT: begin
            if (ground == 1) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = FALL_RIGHT;
            end
        end

        default: begin
            next_state = WALK_LEFT; // safe reset state
        end
    endcase
end

// Outputs are purely based on state (Moore)
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign digging    = is_digging(state);
assign aaah       = is_falling(state);

endmodule