module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // walking_direction: 0 = walk left, 1 = walk right
    reg walking_direction;
    // falling: 1 = falling, 0 = walking
    reg falling;

    // Next values
    reg walking_direction_next;
    reg falling_next;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walking_direction <= 1'b0; // walk left on reset
            falling <= 1'b0;           // not falling on reset
        end else begin
            walking_direction <= walking_direction_next;
            falling <= falling_next;
        end
    end

    // Combinational next state logic
    always @* begin
        // Default assignments
        walking_direction_next = walking_direction;
        falling_next = falling;

        if (falling) begin
            // Currently falling
            if (ground == 1'b1) begin
                falling_next = 1'b0; // Land and resume walking
                // walking_direction stays the same
            end
            // else remain falling
        end else begin
            // Currently walking
            if (ground == 1'b0) begin
                falling_next = 1'b1; // Start falling
                // walking_direction unchanged
            end else begin
                // ground == 1 and walking
                // Check bump signals, switch direction if bumped on any side
                if (bump_left || bump_right) begin
                    walking_direction_next = ~walking_direction;
                end
            end
        end
    end

    // Outputs (Moore)
    assign walk_left  = (falling == 1'b0) && (walking_direction == 1'b0);
    assign walk_right = (falling == 1'b0) && (walking_direction == 1'b1);
    assign aaah       = falling;

endmodule