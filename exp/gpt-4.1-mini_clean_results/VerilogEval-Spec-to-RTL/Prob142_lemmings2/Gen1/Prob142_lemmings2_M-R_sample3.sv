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

    // Registers to track walking direction and falling state
    // walking_dir: 0 = left, 1 = right
    reg walking_dir;
    reg falling;

    // next state signals
    reg walking_dir_next;
    reg falling_next;

    // Asynchronous reset (positive edge)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walking_dir <= 1'b0; // walk left
            falling <= 1'b0;
        end else begin
            walking_dir <= walking_dir_next;
            falling <= falling_next;
        end
    end

    // Next state combinational logic
    always @(*) begin
        falling_next = falling;
        walking_dir_next = walking_dir;

        // Update falling based on ground
        if (ground == 1'b0)
            falling_next = 1'b1;
        else
            falling_next = 1'b0;

        // Update walking direction only if not falling
        // If bumped on either side (or both), flip direction
        if (!falling) begin
            if (bump_left || bump_right) begin
                walking_dir_next = ~walking_dir;
            end
            // else keep same direction
        end
        // If falling, ignore bumps, keep walking_dir unchanged
    end

    // Outputs: Moore style outputs depend only on current state
    assign walk_left  = (falling == 1'b0) && (walking_dir == 1'b0);
    assign walk_right = (falling == 1'b0) && (walking_dir == 1'b1);
    assign aaah       = falling;

endmodule