module TopModule (
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

    // One-hot state encoding
    reg walking_left, walking_right, falling, digging_left, digging_right, splatter;
    reg [4:0] fall_timer;
    reg direction; // 0=left, 1=right

    // State transition and timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_left <= 1;
            walking_right <= 0;
            falling <= 0;
            digging_left <= 0;
            digging_right <= 0;
            splatter <= 0;
            fall_timer <= 0;
            direction <= 0;
        end else if (!splatter) begin
            // Update fall timer
            if (falling && !ground)
                fall_timer <= fall_timer + 1;
            else
                fall_timer <= 0;

            // State transitions with priority: fall > dig > bump
            if ((walking_left || walking_right || digging_left || digging_right) && !ground) begin
                // Start falling
                walking_left <= 0;
                walking_right <= 0;
                digging_left <= 0;
                digging_right <= 0;
                falling <= 1;
            end else if (falling && ground) begin
                // Stop falling
                falling <= 0;
                if (fall_timer > 20) begin
                    splatter <= 1;
                end else begin
                    walking_left <= ~direction;
                    walking_right <= direction;
                end
            end else if ((walking_left || walking_right) && ground && dig) begin
                // Start digging
                walking_left <= 0;
                walking_right <= 0;
                digging_left <= ~direction;
                digging_right <= direction;
            end else if (walking_left && (bump_left || (bump_left && bump_right))) begin
                // Change direction from left to right
                walking_left <= 0;
                walking_right <= 1;
                direction <= 1;
            end else if (walking_right && (bump_right || (bump_left && bump_right))) begin
                // Change direction from right to left
                walking_left <= 1;
                walking_right <= 0;
                direction <= 0;
            end
            // Else maintain current state
        end
    end

    // Output assignments
    assign walk_left = walking_left && !splatter;
    assign walk_right = walking_right && !splatter;
    assign aaah = falling && !splatter;
    assign digging = (digging_left || digging_right) && !splatter;

endmodule