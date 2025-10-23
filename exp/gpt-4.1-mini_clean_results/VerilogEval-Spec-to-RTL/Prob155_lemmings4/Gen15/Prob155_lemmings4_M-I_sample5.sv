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

    // State registers with asynchronous posedge reset
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
        // Defaults to hold state and reset fall timer if not falling
        next_mode = mode;
        next_fall_timer = (mode == MODE_FALL) ? fall_timer : 5'd0;

        // Direction next: update only in walking mode on bumps; else hold direction
        // Combine bump logic: if any bump, invert or set direction
        // direction update: if bump_left or bump_right, direction changes accordingly:
        // if both bumped, invert direction
        // else bump_left -> walk right; bump_right -> walk left
        // else hold direction
        if (mode == MODE_WALK) begin
            if (bump_left && bump_right)
                next_direction = ~direction;
            else if (bump_left)
                next_direction = 1'b1;
            else if (bump_right)
                next_direction = 1'b0;
            else
                next_direction = direction;
        end else begin
            next_direction = direction;
        end

        case (mode)
            MODE_SPLAT: begin
                // Stuck forever
                next_mode = MODE_SPLAT;
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT; // splat
                    else
                        next_mode = MODE_WALK;  // resume walking
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue falling with saturating increment at 31
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_mode = MODE_DIG;
                end
                // direction already handled above
            end

            MODE_DIG: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                end
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule