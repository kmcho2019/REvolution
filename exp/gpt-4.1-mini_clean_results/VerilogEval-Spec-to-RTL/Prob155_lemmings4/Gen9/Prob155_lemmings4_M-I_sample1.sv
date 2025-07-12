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

    // Mode/state encoding: 2 bits
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // fall duration counter

    // Bump signals combined once for simpler logic
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;
    wire bump_left_only = bump_left & ~bump_right;
    wire bump_right_only = bump_right & ~bump_left;

    // Asynchronous reset and sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;  // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next-state logic
    always @(*) begin
        // Defaults to hold current values, avoid unnecessary toggling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted
                next_mode = MODE_SPLAT;
                // direction and timer unchanged
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: check fall duration for splat
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                    end else begin
                        next_mode = MODE_WALK;
                    end
                    next_fall_timer = 5'd0; // reset fall timer on landing
                    // direction unchanged
                end else begin
                    // Continue falling, increment timer saturating at 31
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer; // hold max count
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Falling overrides all
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging only on ground and walking
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end else if (bump) begin
                    // On bump, change direction as specified
                    // Both bumps toggle direction
                    // bump_left only -> walk right
                    // bump_right only -> walk left
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (both_bump)
                        next_direction = ~direction;
                    else if (bump_left_only)
                        next_direction = 1'b1;  // walk right
                    else
                        next_direction = 1'b0;  // walk left (bump_right_only)
                end else begin
                    // Continue walking same direction
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Lose ground while digging: start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else begin
                    // Continue digging on ground
                    next_mode = MODE_DIG;
                    // fall_timer unchanged or zero
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Safety: reset to walking left
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