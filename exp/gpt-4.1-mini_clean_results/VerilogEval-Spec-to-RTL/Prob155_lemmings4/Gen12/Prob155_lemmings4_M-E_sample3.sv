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

    // One-hot state bits
    reg walk_left_state, walk_right_state;
    reg dig_state;
    reg fall_state;
    reg splat_state;

    reg [4:0] fall_timer;

    // Next state signals
    reg next_walk_left_state, next_walk_right_state;
    reg next_dig_state;
    reg next_fall_state;
    reg next_splat_state;
    reg [4:0] next_fall_timer;

    // Combinational next state logic
    always @(*) begin
        // Defaults
        next_walk_left_state = 0;
        next_walk_right_state = 0;
        next_dig_state = 0;
        next_fall_state = 0;
        next_splat_state = 0;
        next_fall_timer = fall_timer;

        if (splat_state) begin
            // Once splatted, stay splatted forever
            next_splat_state = 1'b1;
            next_fall_timer = 5'd0;
        end else if (fall_state) begin
            // Falling state logic
            if (ground) begin
                // Hit ground: check for splatter
                if (fall_timer > 5'd20) begin
                    next_splat_state = 1'b1;
                    next_fall_timer = 5'd0;
                end else begin
                    // Return to walking in previous direction
                    if (walk_left_state || dig_state)
                        next_walk_left_state = 1'b1;
                    else if (walk_right_state)
                        next_walk_right_state = 1'b1;
                    else
                        next_walk_left_state = 1'b1; // Default left
                    next_fall_timer = 5'd0;
                end
            end else begin
                // Continue falling and increment timer (saturate at 31)
                next_fall_state = 1'b1;
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 1'b1;
                else
                    next_fall_timer = fall_timer;
            end
        end else if (dig_state) begin
            // Digging state logic
            if (!ground) begin
                // Ground gone: start falling, keep direction from digging
                next_fall_state = 1'b1;
                next_fall_timer = 5'd1;
            end else begin
                // Continue digging
                next_dig_state = 1'b1;
                next_fall_timer = 5'd0;
            end
        end else if (walk_left_state || walk_right_state) begin
            // Walking states logic
            // Determine current direction flag
            wire direction_left = walk_left_state;
            wire direction_right = walk_right_state;

            if (!ground) begin
                // Start falling from walking
                next_fall_state = 1'b1;
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // Start digging only if on ground and walking
                next_dig_state = 1'b1;
                next_fall_timer = 5'd0;
            end else if (bump_left && bump_right) begin
                // Both bumps flip direction
                if (direction_left) begin
                    next_walk_right_state = 1'b1;
                end else begin
                    next_walk_left_state = 1'b1;
                end
                next_fall_timer = 5'd0;
            end else if (bump_left) begin
                // Bumped left -> walk right
                next_walk_right_state = 1'b1;
                next_fall_timer = 5'd0;
            end else if (bump_right) begin
                // Bumped right -> walk left
                next_walk_left_state = 1'b1;
                next_fall_timer = 5'd0;
            end else begin
                // Keep walking same direction
                if (direction_left)
                    next_walk_left_state = 1'b1;
                else
                    next_walk_right_state = 1'b1;
                next_fall_timer = 5'd0;
            end
        end else begin
            // No valid walking/dig/fall/splat: default to walking left
            next_walk_left_state = 1'b1;
            next_fall_timer = 5'd0;
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state <= 1'b1;
            walk_right_state <= 1'b0;
            dig_state <= 1'b0;
            fall_state <= 1'b0;
            splat_state <= 1'b0;
            fall_timer <= 5'd0;
        end else begin
            walk_left_state <= next_walk_left_state;
            walk_right_state <= next_walk_right_state;
            dig_state <= next_dig_state;
            fall_state <= next_fall_state;
            splat_state <= next_splat_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Outputs (Moore)
    assign walk_left  = walk_left_state && !dig_state && !fall_state && !splat_state;
    assign walk_right = walk_right_state && !dig_state && !fall_state && !splat_state;
    assign aaah       = fall_state;
    assign digging    = dig_state;

endmodule