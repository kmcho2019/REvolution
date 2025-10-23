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

    // State encoding for combined mode and direction
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        DIG_LEFT   = 3'd2,
        DIG_RIGHT  = 3'd3,
        FALL_LEFT  = 3'd4,
        FALL_RIGHT = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer; // 5-bit fall timer (max 31)
    logic ground_d; // delayed ground input for edge detection

    // Asynchronous reset, synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
            ground_d <= 1'b1; // Assume starting on ground
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
            ground_d <= ground;
        end
    end

    // Detect ground edges
    logic ground_fall_start = (ground_d == 1'b1) && (ground == 1'b0);
    logic ground_reappear = (ground_d == 1'b0) && (ground == 1'b1);

    // Bump ignored conditions:
    // Ignore bumps if currently falling, digging, splat, or ground edge event this cycle
    logic bumps_ignored = (state == FALL_LEFT) || (state == FALL_RIGHT) ||
                          (state == DIG_LEFT) || (state == DIG_RIGHT) ||
                          (state == SPLAT) ||
                          ground_fall_start || ground_reappear;

    // Extract direction for FALL and DIG states
    // For SPLAT, direction irrelevant
    function logic is_left_dir(state_t s);
        case (s)
            WALK_LEFT, DIG_LEFT, FALL_LEFT: is_left_dir = 1'b1;
            default: is_left_dir = 1'b0;
        endcase
    endfunction

    // State transition logic
    always_comb begin
        // Defaults
        next_state = state;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Stay splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            // Walking states
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    // Ground disappeared, start falling with same direction
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging (higher priority than bumps)
                    next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    next_fall_timer = 5'd0;
                end else if (!bumps_ignored && (bump_left || bump_right)) begin
                    // Direction flip on bump(s)
                    next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    next_fall_timer = 5'd0;
                end else begin
                    // Stay walking same direction
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            // Digging states
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    // Lost ground while digging -> start falling same direction
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            // Falling states
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // Landed on ground
                    if (fall_timer > 5'd20) begin
                        // Fall too long -> splat
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Safe landing -> resume walking same direction
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Still falling, increment fall_timer saturating at 31
                    next_state = state;
                    next_fall_timer = (fall_timer == 5'd31) ? fall_timer : (fall_timer + 5'd1);
                end
            end

            default: begin
                // Safety fallback to WALK_LEFT
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs decoding
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule