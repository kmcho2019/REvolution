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

    // State signals (one-hot style)
    reg walking_left;
    reg walking_right;
    reg falling;

    // Direction stored separately for falling state: 0 = left, 1 = right
    reg direction;

    // Combine bumps for logic
    wire bump_both = bump_left & bump_right;
    wire bump_left_only  = bump_left & ~bump_right;
    wire bump_right_only = ~bump_left & bump_right;

    // Next state logic
    reg walking_left_nxt;
    reg walking_right_nxt;
    reg falling_nxt;
    reg direction_nxt;

    always @(*) begin
        // Default next state: hold current
        walking_left_nxt  = walking_left;
        walking_right_nxt = walking_right;
        falling_nxt       = falling;
        direction_nxt     = direction;

        if (!falling) begin
            // Currently walking
            if (ground == 1'b0) begin
                // Ground lost -> start falling, store direction
                falling_nxt = 1'b1;
                walking_left_nxt  = 1'b0;
                walking_right_nxt = 1'b0;
                direction_nxt = walking_right ? 1'b1 : 1'b0;
            end else begin
                // Ground present, process bumps
                if (bump_both) begin
                    // Both bumps -> toggle direction
                    walking_left_nxt  = walking_right;
                    walking_right_nxt = walking_left;
                    direction_nxt = walking_right ? 1'b0 : 1'b1;
                end else if (bump_left_only) begin
                    // Bump left -> walk right
                    walking_left_nxt  = 1'b0;
                    walking_right_nxt = 1'b1;
                    direction_nxt = 1'b1;
                end else if (bump_right_only) begin
                    // Bump right -> walk left
                    walking_left_nxt  = 1'b1;
                    walking_right_nxt = 1'b0;
                    direction_nxt = 1'b0;
                end else begin
                    // No bump, keep current direction
                    walking_left_nxt  = walking_left;
                    walking_right_nxt = walking_right;
                    direction_nxt = walking_right ? 1'b1 : 1'b0;
                end
                falling_nxt = 1'b0;
            end
        end else begin
            // Currently falling
            if (ground == 1'b1) begin
                // Ground regained, resume walking in stored direction
                falling_nxt = 1'b0;
                if (direction == 1'b0) begin
                    walking_left_nxt  = 1'b1;
                    walking_right_nxt = 1'b0;
                end else begin
                    walking_left_nxt  = 1'b0;
                    walking_right_nxt = 1'b1;
                end
            end else begin
                // Still falling, direction unchanged, no walking
                falling_nxt = 1'b1;
                walking_left_nxt  = 1'b0;
                walking_right_nxt = 1'b0;
                direction_nxt = direction;
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walking_left  <= 1'b1;
            walking_right <= 1'b0;
            falling       <= 1'b0;
            direction     <= 1'b0; // left
        end else begin
            walking_left  <= walking_left_nxt;
            walking_right <= walking_right_nxt;
            falling       <= falling_nxt;
            direction     <= direction_nxt;
        end
    end

    // Outputs are Moore style signals derived directly from state bits
    assign aaah       = falling;
    assign walk_left  = walking_left;
    assign walk_right = walking_right;

endmodule