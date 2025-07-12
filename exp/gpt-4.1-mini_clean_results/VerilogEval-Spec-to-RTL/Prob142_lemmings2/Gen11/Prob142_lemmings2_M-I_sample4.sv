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

    reg falling;   // 1 = falling, 0 = walking
    reg direction; // 0 = left, 1 = right

    // Compute next direction only when walking and bumped
    wire bump = bump_left | bump_right;
    wire new_direction = bump ? (direction ^ 1'b1) : direction; // flip direction on any bump

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;
            direction <= 1'b0; // walk left initially
        end else begin
            if (falling) begin
                if (ground)
                    falling <= 1'b0; // landed
                // direction remains unchanged while falling
            end else begin
                if (!ground)
                    falling <= 1'b1; // start falling
                else if (bump && (new_direction != direction))
                    direction <= new_direction; // update direction only if changed
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule