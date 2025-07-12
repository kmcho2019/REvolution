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

    // State bits: direction (0=left,1=right), falling (0=walking,1=falling)
    reg direction, falling;
    reg next_direction, next_falling;

    // Combinational next state logic
    always @(*) begin
        // Default next states retain current state
        next_direction = direction;
        next_falling = falling;

        if (falling) begin
            // Currently falling
            if (ground) begin
                // Landed: stop falling, keep direction
                next_falling = 1'b0;
                // direction unchanged
            end else begin
                // Still falling
                next_falling = 1'b1;
            end
            // Bumps ignored when falling
        end else begin
            // Currently walking
            if (!ground) begin
                // Ground lost: start falling, keep direction
                next_falling = 1'b1;
                // direction unchanged
            end else begin
                // Walking on ground: respond to bumps
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // Bumped on left: walk right (direction=1)
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // Bumped on right: walk left (direction=0)
                    next_direction = 1'b0;
                end
                // else no bumps: direction unchanged
                next_falling = 1'b0;
            end
        end
    end

    // Sequential state updates with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling <= 1'b0;   // not falling
        end else begin
            direction <= next_direction;
            falling <= next_falling;
        end
    end

    // Moore outputs decoded from current state
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule