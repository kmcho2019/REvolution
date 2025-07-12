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

    // State registers: falling and direction
    // falling: 0 = walking, 1 = falling
    // direction: 0 = left, 1 = right
    reg falling, direction;
    reg next_falling, next_direction;

    // Combinational next-state logic
    always @(*) begin
        // Default: hold current state
        next_falling = falling;
        next_direction = direction;

        if (falling) begin
            // Currently falling
            if (ground)
                next_falling = 1'b0; // Land, resume walking
            // else remain falling, direction unchanged
        end else begin
            // Currently walking
            if (!ground) begin
                // Ground disappeared: start falling, keep direction
                next_falling = 1'b1;
            end else begin
                // Ground present and walking, bumps can change direction
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bump on left: walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bump on right: walk left
                    next_direction = 1'b0;
                end
                // else no change in direction
            end
        end
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling <= 1'b0;    // start walking
            direction <= 1'b0;  // walk left initially
        end else begin
            falling <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs derived directly from state
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule