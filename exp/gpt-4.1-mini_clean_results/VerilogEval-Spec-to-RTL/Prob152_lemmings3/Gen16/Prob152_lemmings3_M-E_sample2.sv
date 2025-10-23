module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot encoded mode states
    reg walk, fall, dig_state;
    reg dir; // 0 = left, 1 = right

    // Next state signals
    reg walk_next, fall_next, dig_next;
    reg dir_next;

    // Helper signals
    wire bumped = bump_left | bump_right;
    wire bumped_both = bump_left & bump_right;

    always @(*) begin
        // Default next state values: hold current
        walk_next = walk;
        fall_next = fall;
        dig_next  = dig_state;
        dir_next = dir;

        if (walk) begin
            // Priority: fall > dig > bump direction change
            if (!ground) begin
                // start falling, keep direction
                walk_next = 0;
                fall_next = 1;
                dig_next  = 0;
            end else if (dig) begin
                // start digging, keep direction
                walk_next = 0;
                fall_next = 0;
                dig_next  = 1;
            end else if (bumped) begin
                // switch direction based on bump
                // If both bumped, toggle direction
                if (bumped_both)
                    dir_next = ~dir;
                else if (bump_left)
                    dir_next = 1'b1; // walk right
                else // bumped on right
                    dir_next = 1'b0; // walk left
            end
            // else keep walking same direction
        end else if (fall) begin
            // Falling continues until ground
            if (ground) begin
                // back to walking same direction
                walk_next = 1;
                fall_next = 0;
                dig_next  = 0;
                // direction unchanged
            end
            // else keep falling
        end else if (dig_state) begin
            // Digging continues until no ground => fall
            if (!ground) begin
                dig_next  = 0;
                fall_next = 1;
                walk_next = 0;
                // direction unchanged
            end
            // else keep digging
        end
    end

    // Sequential updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize to walk left
            walk <= 1'b1;
            fall <= 1'b0;
            dig_state <= 1'b0;
            dir <= 1'b0; // walk left
        end else begin
            walk <= walk_next;
            fall <= fall_next;
            dig_state <= dig_next;
            dir <= dir_next;
        end
    end

    // Output assignments (Moore)
    assign walk_left  = walk & ~dir;
    assign walk_right = walk & dir;
    assign aaah       = fall;
    assign digging    = dig_state;

endmodule