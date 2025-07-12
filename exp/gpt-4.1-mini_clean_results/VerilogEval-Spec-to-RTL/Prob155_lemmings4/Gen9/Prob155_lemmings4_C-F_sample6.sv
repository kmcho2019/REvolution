module TopModule (
    input  clk,
    input  areset,         // asynchronous positive-edge reset
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
    localparam [1:0]
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3;

    // Direction encoding
    localparam DIR_LEFT  = 1'b0;
    localparam DIR_RIGHT = 1'b1;

    // State, direction, and fall timer registers
    reg [1:0] mode, next_mode;
    reg direction, next_direction;
    reg [4:0] fall_timer, next_fall_timer;  // counts falling cycles, saturates at 31

    // Asynchronous reset and sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= DIR_LEFT;
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            if (direction != next_direction)
                direction <= next_direction;
            if (fall_timer != next_fall_timer)
                fall_timer <= next_fall_timer;
        end
    end

    // Next state and outputs logic (combinational)
    always @(*) begin
        // Defaults: hold current values
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_mode = MODE_SPLAT;
                next_fall_timer = 5'd0;
                // direction irrelevant but hold for consistency
                next_direction = direction;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: check splatter threshold
                    if (fall_timer > 5'd20) begin
                        next_mode = MODE_SPLAT;
                        next_fall_timer = 5'd0;
                        next_direction = direction;
                    end else begin
                        // Resume walking after fall
                        next_mode = MODE_WALK;
                        next_fall_timer = 5'd0;
                        next_direction = direction;
                    end
                end else begin
                    // Continue falling, saturate fall_timer at 31
                    next_mode = MODE_FALL;
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 5'd1) : fall_timer;
                    next_direction = direction;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Fall has highest precedence
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Digging second precedence; only if on ground and walking
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Handle bump direction switching
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left && bump_right) begin
                        // bumped both: toggle direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // bumped left only: walk right
                        next_direction = DIR_RIGHT;
                    end else if (bump_right) begin
                        // bumped right only: walk left
                        next_direction = DIR_LEFT;
                    end else begin
                        // no bump: direction unchanged
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Falling overrides digging when ground disappears
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging; bumps or dig ignored during digging
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Safety fallback: walk left
                next_mode = MODE_WALK;
                next_direction = DIR_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs as Moore machine outputs: depend only on current mode and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == DIR_LEFT);
    assign walk_right = (mode == MODE_WALK) && (direction == DIR_RIGHT);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule