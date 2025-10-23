module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // Separate state bits
    reg direction; // 0 = left, 1 = right
    reg falling;   // 0 = walking, 1 = falling

    // Next state signals
    reg next_direction;
    reg next_falling;

    always @(*) begin
        // Default next states are current states
        next_direction = direction;
        next_falling = falling;

        if (falling) begin
            // Currently falling
            if (ground) begin
                // Ground reappeared, stop falling, direction unchanged
                next_falling = 1'b0;
            end
            // Ignore bumps while falling
        end else begin
            // Currently walking
            if (!ground) begin
                // Ground disappeared, start falling, direction preserved
                next_falling = 1'b1;
            end else begin
                // On ground and walking, bumps may change direction
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_direction = 1'b0;
                end
                // else no bumps: direction unchanged
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // Walk left on reset
            falling <= 1'b0;   // Start walking (not falling)
        end else begin
            direction <= next_direction;
            falling <= next_falling;
        end
    end

    // Outputs are Moore type, based on current state bits
    assign aaah = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule