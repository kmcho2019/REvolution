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

// Define states enumerating direction and mode explicitly
typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5
} state_t;

state_t state, next_state;

// Synchronous state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    // Defaults
    next_state = state;

    // Convenience signals
    logic bumped;
    logic both_bumps;
    logic only_bump_left;
    logic only_bump_right;

    bumped = bump_left || bump_right;
    both_bumps = bump_left && bump_right;
    only_bump_left = bump_left && !bump_right;
    only_bump_right = bump_right && !bump_left;

    case (state)
        // WALKING states
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (dig && ground) begin
                next_state = DIG_LEFT;
            end else if (bumped) begin
                if (both_bumps)
                    next_state = WALK_RIGHT; // flip direction
                else if (only_bump_left)
                    next_state = WALK_RIGHT;
                else if (only_bump_right)
                    next_state = WALK_LEFT; // already walking left, remain
                else
                    next_state = WALK_LEFT; // no bump change
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (dig && ground) begin
                next_state = DIG_RIGHT;
            end else if (bumped) begin
                if (both_bumps)
                    next_state = WALK_LEFT; // flip direction
                else if (only_bump_left)
                    next_state = WALK_RIGHT; // already right, remain
                else if (only_bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT; // no bump change
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        // FALLING states
        FALL_LEFT: begin
            if (ground)
                next_state = WALK_LEFT;
            else
                next_state = FALL_LEFT;
        end

        FALL_RIGHT: begin
            if (ground)
                next_state = WALK_RIGHT;
            else
                next_state = FALL_RIGHT;
        end

        // DIGGING states
        DIG_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
            else
                next_state = DIG_LEFT;
        end

        DIG_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else
                next_state = DIG_RIGHT;
        end

        default: begin
            next_state = WALK_LEFT; // Safe reset fallback
        end
    endcase
end

// Outputs: walking, falling (aaah), digging
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule