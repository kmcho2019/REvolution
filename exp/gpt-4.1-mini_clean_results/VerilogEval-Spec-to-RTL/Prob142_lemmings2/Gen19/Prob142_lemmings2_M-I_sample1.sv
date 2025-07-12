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

    reg direction;  // 0=left, 1=right
    reg falling;

    // Next state signals
    reg next_direction;
    reg next_falling;

    always @(*) begin
        next_direction = direction;
        next_falling = falling;

        if (!falling) begin
            // Walking state
            if (!ground) begin
                // Ground disappeared, start falling (keep direction)
                next_falling = 1'b1;
            end else begin
                // Ground present and walking: bumps may cause direction changes
                if (bump_left && bump_right) begin
                    // Bumped both sides: flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped left: walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bumped right: walk left
                    next_direction = 1'b0;
                end
                // else no bumps: remain same direction
            end
        end else begin
            // Falling state
            if (ground) begin
                // Ground reappeared, resume walking
                next_falling = 1'b0;
                // direction unchanged
            end
            // else remain falling, direction unchanged
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling   <= 1'b0; // walking state
        end else begin
            direction <= next_direction;
            falling   <= next_falling;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule