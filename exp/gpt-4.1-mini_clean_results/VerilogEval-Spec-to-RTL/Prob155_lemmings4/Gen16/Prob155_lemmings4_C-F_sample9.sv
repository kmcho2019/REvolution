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

    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0 = left, 1 = right
    logic [4:0] fall_timer, next_fall_timer; // 5-bit saturating counter

    // Internal signals
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;
    wire splat_condition = (fall_timer > 5'd20);

    // State and registers update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic with priority: FALL > DIG > bump/direction change
    always_comb begin
        // defaults: hold current values
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain splatted forever; fall_timer zeroed for safety
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                // direction holds
            end
            FALL: begin
                if (ground) begin
                    // Landed, check splat
                    if (splat_condition) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 5'd0;
                    end
                    // Direction unchanged on landing
                    next_direction = direction;
                end else begin
                    // Keep falling, saturate counter at max 31
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 5'd1;
                end
            end
            WALK: begin
                if (!ground) begin
                    // Start falling on losing ground
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction; // direction unchanged while falling
                end else if (dig) begin
                    // Start digging only on ground and not falling
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Still walking on ground - consider bump direction changes
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    // Handle bump logic with proper priority
                    if (bump_both) begin
                        next_direction = ~direction; // toggle direction
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end
            DIG: begin
                if (!ground) begin
                    // Start falling if ground disappears
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end
            default: begin
                // Safe fallback to walking left
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule