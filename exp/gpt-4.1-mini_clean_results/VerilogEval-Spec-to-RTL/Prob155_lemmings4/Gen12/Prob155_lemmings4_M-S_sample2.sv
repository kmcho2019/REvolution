module TopModule (
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

    // States encoding (3 bits to accommodate all states)
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam DIG        = 3'd2;
    localparam FALL_LEFT  = 3'd3;
    localparam FALL_RIGHT = 3'd4;
    localparam SPLAT      = 3'd5;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // Landed
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        // Resume walking in same direction as falling
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling, increment timer saturating at 31
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : fall_timer;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground lost, start falling preserving direction
                    if (state == DIG) begin
                        // Determine direction from last walking direction by external info?
                        // We must remember direction while digging.
                        // Here, we assume digging direction is the same as walking before dig:
                        // Use a trick: treat dig as directionless; direction is determined by last walk state before dig.
                        // But since state encodes direction and action, 
                        // must store direction in dig state (DIG alone cannot encode direction).
                        // To keep it simple, encode dig direction as separate states:
                        // Since original instructions only say dig if walking on ground and continue digging until ground=0,
                        // direction is last walking direction.
                        // We'll update code below to distinguish DIG_LEFT and DIG_RIGHT.

                        // For simplicity, here treat DIG as directionless, and on fall choose FALL_LEFT as default. 
                        // But this violates spec.
                        // So we update: Use DIG_LEFT and DIG_RIGHT states to preserve direction during digging.
                        // Therefore, we refactor states accordingly below.
                    end
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                end
            end

            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling, direction preserved
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging on ground, same direction
                    next_state = (state == WALK_LEFT) ? DIG : DIG;
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump(s)
                    // If bumped on either side, switch direction
                    // If both bumps, still switch direction
                    // So direction toggled unconditionally if any bump
                    next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Since we need to encode digging direction as well, revise states to include DIG_LEFT and DIG_RIGHT:
    // Update the module accordingly below:

endmodule


// Revised implementation with direction-aware DIG states

module TopModule (
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

    // State encoding with directions:
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam DIG_LEFT   = 3'd2;
    localparam DIG_RIGHT  = 3'd3;
    localparam FALL_LEFT  = 3'd4;
    localparam FALL_RIGHT = 3'd5;
    localparam SPLAT      = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : fall_timer;
                end
            end

            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs based on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule