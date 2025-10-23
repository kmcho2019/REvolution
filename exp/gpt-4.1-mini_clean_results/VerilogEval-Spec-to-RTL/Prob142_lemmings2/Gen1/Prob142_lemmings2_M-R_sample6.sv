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

    // Sequential logic for state updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_dir   <= 1'b0; // walk left on reset
            falling    <= 1'b0;
            prev_walk_dir <= 1'b0;
        end else begin
            walk_dir <= next_walk_dir;
            falling  <= next_falling;
            // Update prev_walk_dir only when not falling
            if (!falling)
                prev_walk_dir <= next_walk_dir;
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_falling = falling;
        next_walk_dir = walk_dir;

        if (!falling) begin
            // When on ground and walking
            if (!ground) begin
                // start falling
                next_falling = 1'b1;
                // walking direction remains unchanged
            end else begin
                // walking on ground, bumps cause direction flip
                if (bump_left || bump_right) begin
                    next_walk_dir = ~walk_dir;
                end
            end
        end else begin
            // currently falling
            if (ground) begin
                // land, stop falling, restore walking direction before fall
                next_falling = 1'b0;
                next_walk_dir = prev_walk_dir;
            end
            // bumps ignored while falling, walking direction unchanged
        end
    end

    // Output logic (Moore)
    assign walk_left = (falling == 0) && (walk_dir == 1'b0);
    assign walk_right = (falling == 0) && (walk_dir == 1'b1);
    assign aaah = falling;

endmodule