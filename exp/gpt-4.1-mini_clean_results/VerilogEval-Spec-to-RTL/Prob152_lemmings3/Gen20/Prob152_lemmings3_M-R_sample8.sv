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

    // Separate state bits: direction and mode
    // direction: 0=left, 1=right
    // mode: 0=walk, 1=fall
    reg direction, mode;
    reg digging_r;

    // Next state signals (combinational)
    reg next_direction, next_mode, next_digging;

    // Compute next state logic in combinational block
    always @(*) begin
        // Defaults: hold current values
        next_direction = direction;
        next_mode = mode;
        next_digging = digging_r;

        // Priority 1: falling if no ground
        if (!ground) begin
            next_mode = 1'b1;       // fall mode
            next_digging = 1'b0;    // stop digging when fall
            // direction unchanged during fall
        end else if (mode == 1'b1) begin
            // Was falling and ground returned: resume walking no digging
            next_mode = 1'b0;       // walk mode
            next_digging = 1'b0;
            // direction unchanged
        end else begin
            // mode == walk and ground == 1
            if (digging_r) begin
                // Continue digging until ground lost (handled above)
                next_digging = 1'b1;
                // direction and mode unchanged
            end else begin
                if (dig) begin
                    // Start digging only when walking on ground and not falling
                    next_digging = 1'b1;
                    // mode and direction unchanged
                end else if (bump_left || bump_right) begin
                    // Change direction on bump only if not digging or falling
                    if (bump_left && bump_right) begin
                        next_direction = ~direction; // flip direction
                    end else if (bump_left) begin
                        next_direction = 1'b1;       // walk right
                    end else begin
                        next_direction = 1'b0;       // walk left
                    end
                    next_digging = 1'b0; // ensure digging off
                    next_mode = 1'b0;    // remain walking
                end else begin
                    // No bumps, no dig, no fall
                    next_digging = 1'b0;
                    // direction and mode unchanged
                end
            end
        end
    end

    // Sequential logic: update state on clock or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            mode <= 1'b0;      // walk mode
            digging_r <= 1'b0;
        end else begin
            direction <= next_direction;
            mode <= next_mode;
            digging_r <= next_digging;
        end
    end

    // Outputs: Moore outputs depend on registered state
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule