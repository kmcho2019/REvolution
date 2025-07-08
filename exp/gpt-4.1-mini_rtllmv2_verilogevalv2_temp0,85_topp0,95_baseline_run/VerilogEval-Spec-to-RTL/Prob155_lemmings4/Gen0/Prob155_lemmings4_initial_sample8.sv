module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum reg [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;

    reg [5:0] fall_count; // enough to count >20 (6 bits)

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 6'd0;
        end else begin
            state <= next_state;
            // fall_count increment only in FALL states
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (ground) begin
                    fall_count <= 6'd0; // reset when hitting ground
                end else begin
                    fall_count <= fall_count + 6'd1;
                end
            end else begin
                fall_count <= 6'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default stay

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // If bumped on left or right, switch direction
                    // bump_left -> walk_right, bump_right -> walk_left
                    // If both bumps at once, still switch
                    // Current is WALK_LEFT, switching direction means WALK_RIGHT
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    // Current is WALK_RIGHT, switching direction means WALK_LEFT
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else begin
                    next_state = DIG_LEFT;
                end
            end
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end
            FALL_LEFT: begin
                if (ground) begin
                    if (fall_count > 6'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 6'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end
            SPLAT: begin
                // Stay splatted forever until reset
                next_state = SPLAT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs based on state
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            DIG_LEFT,
            DIG_RIGHT: begin
                digging = 1'b1;
            end
            FALL_LEFT,
            FALL_RIGHT: begin
                aaah = 1'b1;
            end
            SPLAT: begin
                // all zero
            end
        endcase
    end

endmodule