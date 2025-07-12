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

    // Next state logic
    always @(*) begin
        // Defaults: hold current values; fall_timer and fall_too_long cleared unless falling
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;
        next_fall_too_long = 1'b0;

        case (mode)
            MODE_SPLAT: begin
                // Stuck forever
                next_mode = MODE_SPLAT;
                // No changes to other regs needed
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_too_long)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    // Reset counters on landing
                    next_fall_timer = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Continue falling: increment timer and update too_long flag
                    next_fall_timer = fall_timer + 1'b1;
                    // Once count >20, set flag
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                end
                // Direction doesn't change during fall
                next_direction = direction;
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    // direction preserved
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging
                    next_mode = MODE_DIG;
                    // direction preserved
                    next_direction = direction;
                end else begin
                    // Handle bumps to switch direction
                    // Only update direction if bump(s) present
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right)
                            next_direction = ~direction;
                        else if (bump_left)
                            next_direction = 1'b1; // walk right
                        else
                            next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // start falling after digging off ledge
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction = direction;
                end else begin
                    // Continue digging
                    next_mode = MODE_DIG;
                    next_direction = direction;
                end
            end

            default: begin
                // Defensive: fallback to walk left
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