module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // counts how many cycles falling
    reg fall_too_long, next_fall_too_long;

    wire fall_timer_eq_20 = (fall_timer == 5'd20);
    wire fall_timer_en = (mode == MODE_FALL);

    // Async posedge reset registers, with enable for fall_timer and fall_too_long
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            if (fall_timer_en) begin
                fall_timer <= next_fall_timer;
                fall_too_long <= next_fall_too_long;
            end else begin
                fall_timer <= 5'd0;
                fall_too_long <= 1'b0;
            end
        end
    end

    // Next state logic with prioritized conditions:
    // fall > dig > bump (only in walk), bumps ignored in dig/fall
    always @(*) begin
        // Defaults hold current state, reset fall timer and flag unless falling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;
        next_fall_too_long = 1'b0;

        case (mode)
            MODE_SPLAT: begin
                // Splatted: remain here forever, no outputs
                next_mode = MODE_SPLAT;
                next_direction = direction; // direction retained but irrelevant
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splat if fallen too long, else walk
                    if (fall_too_long)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Continue falling: increment timer and update flag
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = fall_timer + 1'b1;
                    // Set flag when timer reaches 20 (after increment)
                    // fall_too_long stays set once set
                    next_fall_too_long = fall_too_long | fall_timer_eq_20;
                end
                // Direction does not change while falling
                next_direction = direction;
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Fall takes precedence over digging and bumping
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1; // start counting fall duration
                    next_fall_too_long = 1'b0;
                    next_direction = direction; // direction preserved while falling
                end else if (dig) begin
                    // Dig if on ground and walking
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Handle bumps if any, switch direction accordingly
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right) begin
                            // Both bumps - toggle direction
                            next_direction = ~direction;
                        end else if (bump_left) begin
                            next_direction = 1'b1; // walk right
                        end else begin
                            next_direction = 1'b0; // walk left
                        end
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // No ground while digging => start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Continue digging, ignore bumps, ignore dig input
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end
            end

            default: begin
                // Defensive: reset to walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule