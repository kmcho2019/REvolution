module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg direction;  // 0 = left, 1 = right
    reg falling;    // 0 = walking, 1 = falling

    // Next-state signals
    reg direction_next;
    reg falling_next;

    // Combinational next-state logic
    always @(*) begin
        direction_next = direction;
        falling_next = falling;

        if (falling == 0) begin
            // Walking state
            if (ground == 1) begin
                // Still on ground
                // If bumped on either side, flip direction
                if (bump_left | bump_right) begin
                    direction_next = ~direction;
                end
                // Otherwise direction unchanged
            end else begin
                // Ground lost: start falling
                falling_next = 1'b1;
                // direction unchanged
            end
        end else begin
            // Falling state
            if (ground == 1) begin
                // Landed: stop falling, resume walking
                falling_next = 1'b0;
                // direction unchanged while falling
            end
            // bumps ignored during falling
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling   <= 1'b0; // not falling
        end else begin
            direction <= direction_next;
            falling   <= falling_next;
        end
    end

    // Output logic (Moore)
    assign aaah       = falling;
    assign walk_left  = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;

endmodule