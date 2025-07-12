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

    // One-hot encoding for modes (4 bits)
    localparam MODE_WALK = 4'b0001;
    localparam MODE_DIG  = 4'b0010;
    localparam MODE_FALL = 4'b0100;
    localparam MODE_SPLAT= 4'b1000;

    reg [3:0] mode, next_mode;
    reg direction, next_direction; // 0=left,1=right

    reg [4:0] fall_timer, next_fall_timer;

    // Splat condition flag
    wire splat_condition = (fall_timer > 5'd20);

    // Clock gating signal for fall_timer register update
    wire fall_active = mode[2]; // MODE_FALL bit

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            if (direction != next_direction)
                direction <= next_direction;
            // Clock gated update for fall_timer
            if (fall_active)
                fall_timer <= next_fall_timer;
            else if (next_mode != MODE_FALL)
                fall_timer <= 5'd0;
        end
    end

    always @(*) begin
        // Default assignments
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        // Handle each mode separately
        if (mode == MODE_SPLAT) begin
            // Stays splatted forever, outputs zeroed later
            next_mode = MODE_SPLAT;
            // fall_timer and direction stable
            next_fall_timer = 5'd0;
        end else if (mode == MODE_FALL) begin
            if (ground) begin
                // Landed
                if (splat_condition) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end
                next_direction = direction;
            end else begin
                // Continue falling, increment timer saturating at 31
                next_mode = MODE_FALL;
                next_direction = direction;
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
            end
        end else if (mode == MODE_WALK) begin
            if (!ground) begin
                // Start falling
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction; // preserve direction
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Walking on ground and not digging or falling
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;

                // Simplify bump logic:
                // If bump_left and bump_right both high, toggle direction.
                // Else if bump_left, direction = right (1)
                // Else if bump_right, direction = left (0)
                // Else no change.
                if (bump_left & bump_right)
                    next_direction = ~direction;
                else if (bump_left)
                    next_direction = 1'b1;
                else if (bump_right)
                    next_direction = 1'b0;
                else
                    next_direction = direction;
            end
        end else if (mode == MODE_DIG) begin
            if (!ground) begin
                // Fall when ground lost while digging
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging on ground, ignore bumps and dig input
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end else begin
            // Safety fallback: reset walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
            next_fall_timer = 5'd0;
        end
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule