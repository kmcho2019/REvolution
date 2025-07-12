module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // direction: 0=left, 1=right
    reg direction, next_direction;
    reg falling, next_falling;

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left
            falling <= 1'b0;
        end else begin
            direction <= next_direction;
            falling <= next_falling;
        end
    end

    // Next state logic
    always @* begin
        // Defaults
        next_direction = direction;
        next_falling = falling;

        if (!falling) begin
            if (ground == 1'b0) begin
                // Start falling, keep direction
                next_falling = 1'b1;
            end else if (bump_left || bump_right) begin
                // Flip direction on bump when not falling
                next_direction = ~direction;
            end
        end else begin
            // currently falling
            if (ground == 1'b1) begin
                // Land and resume walking same direction
                next_falling = 1'b0;
                // direction unchanged
            end
            // else remain falling, ignore bumps
        end
    end

    // Outputs: Moore style
    always @* begin
        walk_left  = (direction == 1'b0) && (falling == 1'b0);
        walk_right = (direction == 1'b1) && (falling == 1'b0);
        aaah       = (falling == 1'b1);
    end

endmodule