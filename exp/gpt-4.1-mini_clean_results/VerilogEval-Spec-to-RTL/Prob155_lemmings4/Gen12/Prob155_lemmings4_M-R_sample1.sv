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

    // One-hot state registers for modes
    logic mode_walk, mode_dig, mode_fall, mode_splat;
    logic next_mode_walk, next_mode_dig, next_mode_fall, next_mode_splat;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // Fall timer (5-bit)
    logic [4:0] fall_timer, next_fall_timer;

    // Combined bump signals
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;
    wire bump_left_only = bump_left & ~bump_right;
    wire bump_right_only = bump_right & ~bump_left;

    // Combinational bump direction toggle logic (no function)
    wire direction_after_bump = (both_bump) ? ~direction :
                                (bump_left_only) ? 1'b1 :  // walk right
                                (bump_right_only) ? 1'b0 : // walk left
                                direction;

    // Next state logic
    always_comb begin
        // Default assignments
        next_mode_walk = mode_walk;
        next_mode_dig = mode_dig;
        next_mode_fall = mode_fall;
        next_mode_splat = mode_splat;

        next_direction = direction;
        next_fall_timer = 5'd0;

        if (mode_splat) begin
            // Stay splatted forever
            next_mode_splat = 1'b1;
            next_mode_walk = 1'b0;
            next_mode_dig = 1'b0;
            next_mode_fall = 1'b0;
            next_direction = direction;
            next_fall_timer = 5'd0;
        end else if (mode_fall) begin
            if (ground) begin
                // Hit ground
                if (fall_timer > 5'd20) begin
                    // Splatter
                    next_mode_splat = 1'b1;
                    next_mode_walk = 1'b0;
                    next_mode_dig = 1'b0;
                    next_mode_fall = 1'b0;
                    next_fall_timer = 5'd0;
                end else begin
                    // Resume walking in same direction
                    next_mode_walk = 1'b1;
                    next_mode_fall = 1'b0;
                    next_mode_dig = 1'b0;
                    next_mode_splat = 1'b0;
                    next_fall_timer = 5'd0;
                end
                next_direction = direction;
            end else begin
                // Keep falling and increment fall timer (saturate at 31)
                next_mode_fall = 1'b1;
                next_mode_walk = 1'b0;
                next_mode_dig = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 5'd1) : 5'd31;
                next_direction = direction;
            end
        end else if (mode_walk) begin
            if (!ground) begin
                // Start falling
                next_mode_fall = 1'b1;
                next_mode_walk = 1'b0;
                next_mode_dig = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else if (dig) begin
                // Start digging
                next_mode_dig = 1'b1;
                next_mode_walk = 1'b0;
                next_mode_fall = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end else if (bump) begin
                // Switch walking direction on bump
                next_mode_walk = 1'b1;
                next_mode_dig = 1'b0;
                next_mode_fall = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd0;
                next_direction = direction_after_bump;
            end else begin
                // Continue walking same direction
                next_mode_walk = 1'b1;
                next_mode_dig = 1'b0;
                next_mode_fall = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end else if (mode_dig) begin
            if (!ground) begin
                // Ground lost, start falling
                next_mode_fall = 1'b1;
                next_mode_walk = 1'b0;
                next_mode_dig = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd1;
                next_direction = direction;
            end else begin
                // Keep digging
                next_mode_dig = 1'b1;
                next_mode_walk = 1'b0;
                next_mode_fall = 1'b0;
                next_mode_splat = 1'b0;
                next_fall_timer = 5'd0;
                next_direction = direction;
            end
        end else begin
            // Defensive: default to walk left if no mode active
            next_mode_walk = 1'b1;
            next_mode_dig = 1'b0;
            next_mode_fall = 1'b0;
            next_mode_splat = 1'b0;
            next_fall_timer = 5'd0;
            next_direction = 1'b0;
        end
    end

    // Sequential block with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode_walk <= 1'b1;
            mode_dig <= 1'b0;
            mode_fall <= 1'b0;
            mode_splat <= 1'b0;
            direction <= 1'b0;  // walk left initially
            fall_timer <= 5'd0;
        end else begin
            mode_walk <= next_mode_walk;
            mode_dig <= next_mode_dig;
            mode_fall <= next_mode_fall;
            mode_splat <= next_mode_splat;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Moore outputs from registered state bits and direction
    assign walk_left  = mode_walk & ~direction;
    assign walk_right = mode_walk & direction;
    assign aaah       = mode_fall;
    assign digging    = mode_dig;

endmodule