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

    // State encoding
    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;
    reg fall_too_long, next_fall_too_long;

    // Async posedge reset registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;       // walk left after reset
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
            fall_too_long <= next_fall_too_long;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default assignments: hold current values, reset fall_timer and fall_too_long unless falling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;
        next_fall_too_long = 1'b0;

        case (mode)
            MODE_SPLAT: begin
                // Stuck forever, outputs all zero, no change
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
                next_fall_too_long = 1'b0;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed on ground
                    if (fall_too_long)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    // Reset timer and flag on landing
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    // Direction unchanged during fall and after landing
                    next_direction = direction;
                end else begin
                    // Continue falling
                    next_mode = MODE_FALL;
                    // Increment fall_timer saturating at 31 to minimize toggling
                    if (fall_timer == 5'd31)
                        next_fall_timer = 5'd31;
                    else
                        next_fall_timer = fall_timer + 1'b1;
                    // Set fall_too_long if timer > 20 once
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                    // Direction unchanged while falling
                    next_direction = direction;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling if no ground
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;   // start counting fall duration
                    next_fall_too_long = 1'b0;
                    next_direction = direction; // direction preserved
                end else if (dig) begin
                    // Start digging on ground if dig asserted
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Walking on ground, handle bumps for direction change
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;

                    if (bump_left && bump_right) begin
                        next_direction = ~direction; // both bumps invert direction
                    end else if (bump_left) begin
                        next_direction = 1'b1; // bump left => walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0; // bump right => walk left
                    end else begin
                        next_direction = direction; // no bump, keep direction
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Fall off edge after digging
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Continue digging on ground, no direction change or timer increment
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end
            end

            default: begin
                // Defensive fallback to walk left
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