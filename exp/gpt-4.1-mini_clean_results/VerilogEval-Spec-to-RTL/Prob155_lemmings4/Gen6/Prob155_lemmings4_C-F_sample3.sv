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

    // Sequential logic: asynchronous posedge reset, registers for FSM
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;   // Start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next-state logic with prioritized if-else ladder
    always @(*) begin
        // Default assignments: hold current state
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = fall_timer;

        if (mode == MODE_SPLAT) begin
            // Remain splatted forever
            next_mode = MODE_SPLAT;
            next_direction = direction;
            next_fall_timer = 5'd0;
        end else if (mode == MODE_FALL) begin
            if (ground) begin
                // Landed: splat if fall longer than 20 cycles else walk
                if (fall_timer > 5'd20) begin
                    next_mode = MODE_SPLAT;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end else begin
                // Continue falling, increment timer saturating at 31
                next_mode = MODE_FALL;
                next_direction = direction;
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 5'd1;
                else
                    next_fall_timer = fall_timer;
            end
        end else if (mode == MODE_DIG) begin
            if (!ground) begin
                // Lost ground while digging, start falling
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Continue digging, ignore bumps and dig input
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end else /* MODE_WALK */ begin
            if (!ground) begin
                // Fall takes priority over dig and bumps
                next_mode = MODE_FALL;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging if on ground
                next_mode = MODE_DIG;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else begin
                // Handle bumps with explicit logic
                next_mode = MODE_WALK;
                next_fall_timer = 5'd0;
                if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end else begin
                    next_direction = direction;
                end
            end
        end
    end

    // Moore outputs depend solely on mode and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule