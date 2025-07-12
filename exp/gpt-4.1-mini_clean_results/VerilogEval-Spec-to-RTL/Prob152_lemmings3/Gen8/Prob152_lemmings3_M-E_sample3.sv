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

    // Mode encoding (2 bits)
    localparam MODE_WALK  = 2'b00;
    localparam MODE_FALL  = 2'b01;
    localparam MODE_DIG   = 2'b10;

    reg [1:0] mode, next_mode;
    reg       direction, next_direction;  // 0 = left, 1 = right

    // Next state logic
    always @(*) begin
        // Default keep current state
        next_mode = mode;
        next_direction = direction;

        case (mode)
            MODE_WALK: begin
                // Falling has highest priority
                if (!ground) begin
                    next_mode = MODE_FALL;
                    // direction unchanged
                end
                // Digging second priority, only if ground and dig=1
                else if (dig) begin
                    next_mode = MODE_DIG;
                    // direction unchanged
                end
                // Otherwise walking mode with bump-based direction switch
                else begin
                    // If bumped on left or right or both, flip direction accordingly
                    // Bumped both sides: flip direction anyway
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // bumped on left means switch direction to right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // bumped on right means switch direction to left
                        next_direction = 1'b0;
                    end
                    // else no bump, direction stays
                end
            end
            MODE_FALL: begin
                // While falling ignore bumps and dig commands
                if (ground) begin
                    // Stop falling, return to walking in same direction
                    next_mode = MODE_WALK;
                end
                // else remain falling
            end
            MODE_DIG: begin
                // While digging ignore bumps and dig commands
                if (!ground) begin
                    // Ground disappeared while digging, transition to falling in same direction
                    next_mode = MODE_FALL;
                end
                // else keep digging
            end
            default: begin
                // Should not occur, default to walking left
                next_mode = MODE_WALK;
                next_direction = 1'b0;
            end
        endcase
    end

    // Sequential update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // left
        end else begin
            mode <= next_mode;
            direction <= next_direction;
        end
    end

    // Outputs decoded from mode and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule