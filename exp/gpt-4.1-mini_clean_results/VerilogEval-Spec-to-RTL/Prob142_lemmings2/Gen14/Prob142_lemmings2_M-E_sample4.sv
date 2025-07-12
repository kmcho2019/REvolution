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

    // One-hot state flip-flops
    reg walk_left_state;
    reg walk_right_state;
    reg falling_state;

    // Direction stored when falling: 0=left,1=right
    reg fall_direction;

    // Next state signals
    reg walk_left_next;
    reg walk_right_next;
    reg falling_next;
    reg fall_direction_next;

    // Auxiliary signals for convenience
    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    always @(*) begin
        // Default next-state assignments (hold current)
        walk_left_next   = walk_left_state;
        walk_right_next  = walk_right_state;
        falling_next     = falling_state;
        fall_direction_next = fall_direction;

        if (falling_state) begin
            // Currently falling
            if (ground) begin
                // Ground returns: resume walking in saved direction
                falling_next = 1'b0;
                fall_direction_next = fall_direction; // keep direction
                if (fall_direction == 1'b0) begin
                    walk_left_next  = 1'b1;
                    walk_right_next = 1'b0;
                end else begin
                    walk_left_next  = 1'b0;
                    walk_right_next = 1'b1;
                end
            end
            // else remain falling, no direction or bump changes
        end else begin
            // Currently walking
            if (!ground) begin
                // Ground lost: start falling, save current direction
                falling_next = 1'b1;
                fall_direction_next = walk_right_state ? 1'b1 : 1'b0;
                walk_left_next  = 1'b0;
                walk_right_next = 1'b0;
            end else begin
                // On ground and walking, bumps can change direction
                if (bump_both) begin
                    // Flip direction
                    if (walk_left_state) begin
                        walk_left_next  = 1'b0;
                        walk_right_next = 1'b1;
                    end else begin
                        walk_left_next  = 1'b1;
                        walk_right_next = 1'b0;
                    end
                end else if (bump_left) begin
                    // bump left => walk right
                    walk_left_next  = 1'b0;
                    walk_right_next = 1'b1;
                end else if (bump_right) begin
                    // bump right => walk left
                    walk_left_next  = 1'b1;
                    walk_right_next = 1'b0;
                end
                // else no bump, keep same direction
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to walking left
            walk_left_state  <= 1'b1;
            walk_right_state <= 1'b0;
            falling_state    <= 1'b0;
            fall_direction   <= 1'b0;
        end else begin
            walk_left_state  <= walk_left_next;
            walk_right_state <= walk_right_next;
            falling_state    <= falling_next;
            fall_direction   <= fall_direction_next;
        end
    end

    // Outputs: Moore outputs from states and stored direction during falling
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;
    assign aaah       = falling_state;

endmodule