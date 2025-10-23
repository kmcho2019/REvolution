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

    // Mode encoding (2-bit)
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right

    // Saturating fall timer counter, max 20 (5 bits)
    // Only increment in FALL mode until saturating at 20
    reg [4:0] fall_timer, next_fall_timer;
    reg fall_too_long, next_fall_too_long;

    // Async posedge reset registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
            fall_too_long <= next_fall_too_long;
        end
    end

    // Next state logic with prioritized conditions (fall > dig > bump)
    always @(*) begin
        // Defaults: keep current state/flags
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;
        next_fall_too_long = fall_too_long;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever; no outputs
                next_mode = MODE_SPLAT;
                // No change to direction, fall timer, or fall_too_long needed
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed on ground: splat if too long fall, else walk
                    if (fall_too_long)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;

                    // Reset fall timer and fall_too_long on landing
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    // Direction remains unchanged
                    next_direction = direction;
                end else begin
                    // Continue falling: increment fall_timer if below 20
                    if (fall_timer < 5'd20)
                        next_fall_timer = fall_timer + 1'b1;
                    else
                        next_fall_timer = fall_timer; // saturate at 20

                    // Set fall_too_long flag once saturates at 20
                    if (!fall_too_long && next_fall_timer == 5'd20)
                        next_fall_too_long = 1'b1;
                    else
                        next_fall_too_long = fall_too_long;

                    // Mode and direction remain
                    next_mode = MODE_FALL;
                    next_direction = direction;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Fall takes precedence
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;    // start timer at 1 (just started falling)
                    next_fall_too_long = 1'b0; // clear flag
                    next_direction = direction; // direction preserved during fall
                end else if (dig) begin
                    // Dig if on ground and walking
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Handle bumps if any
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;

                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right)
                            next_direction = ~direction; // both bumped: toggle
                        else if (bump_left)
                            next_direction = 1'b1;       // bump left => walk right
                        else
                            next_direction = 1'b0;       // bump right => walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Ground lost while digging => fall
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Continue digging; ignore bumps or dig input
                    next_mode = MODE_DIG;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end
            end

            default: begin
                // Defensive default
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