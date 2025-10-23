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

    // One-hot style state registers:
    // walk_left = 1 when walking left
    // walk_right = 1 when walking right
    // falling = 1 when falling (direction is retained in walk_left or walk_right)
    reg walk_left_reg, walk_right_reg, falling_reg;
    reg digging_reg;

    // For direction: walking left if walk_left_reg=1, walking right if walk_right_reg=1
    // falling_reg indicates falling regardless of direction bits
    // digging_reg indicates digging mode when walking on ground

    always @(*) begin
        // Defaults: maintain current states
        // Next state signals
        reg walk_left_next, walk_right_next, falling_next, digging_next;
        walk_left_next = walk_left_reg;
        walk_right_next = walk_right_reg;
        falling_next = falling_reg;
        digging_next = digging_reg;

        // Determine if bumped on left or right
        wire bump = bump_left | bump_right;
        wire bump_both = bump_left & bump_right;

        // Priority: fall > dig > bump

        if (!ground) begin
            // Must fall - falling active, walking direction stays same
            falling_next = 1'b1;
            digging_next = 1'b0; // digging stops when fall starts
            // walking direction bits unchanged to remember direction
            walk_left_next = walk_left_reg;
            walk_right_next = walk_right_reg;
        end else if (falling_reg) begin
            // ground is back, stop falling, resume walking same direction
            falling_next = 1'b0;
            digging_next = 1'b0;
            walk_left_next = walk_left_reg;
            walk_right_next = walk_right_reg;
        end else if (digging_reg) begin
            // currently digging on ground
            if (!ground) begin
                // ground lost during digging, start falling
                falling_next = 1'b1;
                digging_next = 1'b0;
                // walking direction unchanged
                walk_left_next = walk_left_reg;
                walk_right_next = walk_right_reg;
            end else begin
                // continue digging
                digging_next = 1'b1;
                falling_next = 1'b0;
                walk_left_next = walk_left_reg;
                walk_right_next = walk_right_reg;
            end
        end else begin
            // Walking on ground and not digging or falling
            falling_next = 1'b0;
            digging_next = (dig && ground) ? 1'b1 : 1'b0;
            if (bump) begin
                // Change direction on bump
                // If bump both sides, just reverse direction
                if (bump_both) begin
                    // Reverse direction
                    walk_left_next = walk_right_reg;
                    walk_right_next = walk_left_reg;
                end else if (bump_left) begin
                    // bumped left => walk right
                    walk_left_next = 1'b0;
                    walk_right_next = 1'b1;
                end else begin
                    // bumped right => walk left
                    walk_left_next = 1'b1;
                    walk_right_next = 1'b0;
                end
            end else begin
                // No bump, continue walking same direction
                walk_left_next = walk_left_reg;
                walk_right_next = walk_right_reg;
            end
        end

        // Apply next values at posedge clk or async reset outside always @(*)
        // Here just pack next values into variables for next always block
        // We use nonblocking assignments in sequential block below

        // assign to internal signals at clock edge
        // This combinational block outputs next signals as wires
        // We'll need to declare these as reg to hold across blocks

        // Unfortunately, Verilog does not allow assignments to reg declared outside always @(*) 
        // within combinational always blocks; will restructure with separate registers and next regs below

        // To solve this cleanly, declare next state regs outside and assign here
        // Using separate logic below.

    end

    // Declare next-state registers for sequential block
    reg walk_left_next, walk_right_next, falling_next, digging_next;

    always @(*) begin
        // Defaults
        walk_left_next = walk_left_reg;
        walk_right_next = walk_right_reg;
        falling_next = falling_reg;
        digging_next = digging_reg;

        wire bump = bump_left | bump_right;
        wire bump_both = bump_left & bump_right;

        // Priority logic again to assign next state
        if (!ground) begin
            // Falling starts
            falling_next = 1'b1;
            digging_next = 1'b0;
            walk_left_next = walk_left_reg;
            walk_right_next = walk_right_reg;
        end else if (falling_reg) begin
            // Landed
            falling_next = 1'b0;
            digging_next = 1'b0;
            walk_left_next = walk_left_reg;
            walk_right_next = walk_right_reg;
        end else if (digging_reg) begin
            // Continue digging or fall if ground lost (already checked above)
            digging_next = 1'b1;
            falling_next = 1'b0;
            walk_left_next = walk_left_reg;
            walk_right_next = walk_right_reg;
        end else begin
            // Walking state
            falling_next = 1'b0;
            digging_next = (dig && ground) ? 1'b1 : 1'b0;
            if (bump) begin
                if (bump_both) begin
                    // reverse direction
                    walk_left_next = walk_right_reg;
                    walk_right_next = walk_left_reg;
                end else if (bump_left) begin
                    walk_left_next = 1'b0;
                    walk_right_next = 1'b1;
                end else begin // bump_right
                    walk_left_next = 1'b1;
                    walk_right_next = 1'b0;
                end
            end else begin
                walk_left_next = walk_left_reg;
                walk_right_next = walk_right_reg;
            end
        end
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_reg <= 1'b1;   // start walking left
            walk_right_reg <= 1'b0;
            falling_reg <= 1'b0;
            digging_reg <= 1'b0;
        end else begin
            walk_left_reg <= walk_left_next;
            walk_right_reg <= walk_right_next;
            falling_reg <= falling_next;
            digging_reg <= digging_next;
        end
    end

    // Output assignments
    assign walk_left  = walk_left_reg & ~falling_reg & ~digging_reg;
    assign walk_right = walk_right_reg & ~falling_reg & ~digging_reg;
    assign aaah       = falling_reg;
    assign digging    = digging_reg;

endmodule