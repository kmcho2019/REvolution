module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // walking direction: 0 = left, 1 = right
    reg walk_dir, next_walk_dir;
    // falling state: 1 = falling, 0 = walking
    reg falling, next_falling;
    // remember walking direction before falling
    reg prev_walk_dir;
    // register previous ground to detect ground falling edge
    reg ground_d;

    // Sequential logic for state updates with async reset and ground_d register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_dir     <= 1'b0; // walk left on reset
            falling      <= 1'b0;
            prev_walk_dir<= 1'b0;
            ground_d     <= 1'b1; // assume starting on ground
        end else begin
            walk_dir     <= next_walk_dir;
            falling      <= next_falling;
            ground_d     <= ground;

            // Update prev_walk_dir only when not falling and not entering falling this cycle
            // i.e., when falling=0 and not transitioning to falling next cycle
            if (!falling && !(ground_d && !ground)) begin
                prev_walk_dir <= next_walk_dir;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        // Default assignments
        next_falling = falling;
        next_walk_dir = walk_dir;

        // Detect falling transition: ground just disappeared this cycle
        wire falling_start = (ground_d == 1) && (ground == 0);

        if (!falling) begin
            if (falling_start) begin
                // Start falling, walking direction unchanged
                next_falling = 1'b1;
                // bumps ignored in falling start cycle, so do not change walk_dir
                next_walk_dir = walk_dir;
            end else begin
                // On ground, bumps cause direction flip
                if (bump_left || bump_right) begin
                    next_walk_dir = ~walk_dir;
                end
                next_falling = 1'b0;
            end
        end else begin
            // currently falling
            if (ground) begin
                // Land, stop falling, restore walking direction before fall
                next_falling = 1'b0;
                next_walk_dir = prev_walk_dir;
            end else begin
                // still falling, bumps ignored, walking direction unchanged
                next_falling = 1'b1;
                next_walk_dir = walk_dir;
            end
        end
    end

    // Output logic (Moore)
    assign walk_left  = (~falling) && (walk_dir == 1'b0);
    assign walk_right = (~falling) && (walk_dir == 1'b1);
    assign aaah       = falling;

endmodule