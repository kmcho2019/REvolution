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

    // State encoding
    typedef enum logic [1:0] {
        WALK = 2'b00,
        DIG  = 2'b01,
        FALL = 2'b10,
        SPLAT= 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // 5-bit fall timer (counts up to 31)
    logic [4:0] fall_timer, next_fall_timer;

    // Combined bump signal: bump left or right or both
    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Splat condition: fall_timer exceeded 20
    wire splat_condition = (fall_timer > 5'd20);

    // Sequential state and registers update with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;    // walk left after reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always_comb begin
        // Defaults: maintain current values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splatted forever
                next_state      = SPLAT;
                next_fall_timer = 5'd0;  // not used anymore
                // direction unchanged
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (splat_condition) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer = 5'd0;
                    // Direction unchanged upon landing
                    next_direction = direction;
                end else begin
                    // Continue falling, increment fall_timer saturating at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    next_direction = direction; // direction preserved during fall
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging: start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1; // start counting fall time
                    next_direction = direction;
                end else begin
                    // Continue digging, ignore bumps or dig input
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            WALK: begin
                // Priority: Fall > Dig > Bump
                if (!ground) begin
                    // Falling starts
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;  // direction preserved
                end else if (dig) begin
                    // Start digging only if on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Handle bumps to change direction
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_both) begin
                        // Both bumps: toggle direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // bump left: walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // bump right: walk left
                        next_direction = 1'b0;
                    end else begin
                        // no bump, maintain direction
                        next_direction = direction;
                    end
                end
            end

            default: begin
                // Fallback defaults (should not occur)
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