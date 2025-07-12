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
    reg [4:0] fall_timer, next_fall_timer;

    // Async posedge reset registers with non-blocking assignments
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always @(*) begin
        // Defaults: hold current values; fall_timer cleared unless falling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;

        // Combined bump signal for simplification
        wire bumped = bump_left | bump_right;

        case (mode)
            MODE_SPLAT: begin
                // Remain splattered forever
                next_mode = MODE_SPLAT;
                // direction and fall_timer remain unchanged or zero
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: splat if fall_timer > 20
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    // direction remains unchanged
                end else begin
                    // Continue falling: increment saturating at 20
                    if (fall_timer < 5'd20)
                        next_fall_timer = fall_timer + 1'b1;
                    else
                        next_fall_timer = 5'd20;
                    next_mode = MODE_FALL;
                    // direction unchanged
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging
                    next_mode = MODE_DIG;
                    // direction unchanged
                end else if (bumped) begin
                    // Switch direction on bump when walking
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else begin
                        // bump_right only
                        next_direction = 1'b0; // walk left
                    end
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                end else begin
                    // No bumps, continue walking same direction
                    next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Fall off ledge after digging
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    // direction unchanged
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Defensive fallback to walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule