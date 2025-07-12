module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode signals: exactly one should be active except splatted (all 0)
    // walking, falling, digging, splatted
    reg walking;
    reg falling;
    reg digging_mode;
    reg splatted;

    reg direction; // 0 = left, 1 = right
    reg [4:0] fall_timer; // counts falling cycles (0..31)

    wire bumped = bump_left | bump_right;
    wire bumped_both = bump_left & bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset: walk left, no fall, not digging, not splatted
            walking    <= 1'b1;
            falling    <= 1'b0;
            digging_mode <= 1'b0;
            splatted   <= 1'b0;
            direction  <= 1'b0; // walk left
            fall_timer <= 5'd0;
        end else if (!splatted) begin
            // Update fall_timer
            if (falling) begin
                // increment saturating at 31
                if (fall_timer != 5'd31)
                    fall_timer <= fall_timer + 1'b1;
            end else begin
                fall_timer <= 5'd0;
            end

            // Falling has highest priority
            if (falling) begin
                if (ground) begin
                    // Landed, check splatter condition
                    if (fall_timer > 5'd20) begin
                        splatted <= 1'b1;
                        walking <= 1'b0;
                        falling <= 1'b0;
                        digging_mode <= 1'b0;
                    end else begin
                        walking <= 1'b1;
                        falling <= 1'b0;
                        digging_mode <= 1'b0;
                    end
                    // direction stays the same
                end
                // else continue falling, no changes to walking/digging
            end else if (digging_mode) begin
                // Currently digging
                if (!ground) begin
                    // Start falling if ground disappears during digging
                    falling <= 1'b1;
                    walking <= 1'b0;
                    digging_mode <= 1'b0;
                    // fall_timer reset handled above
                end
                // else continue digging
                // bump and dig inputs ignored while digging
            end else if (walking) begin
                // Walking and ground is present
                if (!ground) begin
                    // ground gone -> start falling
                    falling <= 1'b1;
                    walking <= 1'b0;
                    digging_mode <= 1'b0;
                    // fall_timer reset handled above
                end else if (dig) begin
                    // start digging if dig input asserted
                    digging_mode <= 1'b1;
                    walking <= 1'b0;
                    falling <= 1'b0;
                    // direction remains
                end else begin
                    // handle bumps for direction change
                    if (bumped_both) begin
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= 1'b1; // walk right
                    end else if (bump_right) begin
                        direction <= 1'b0; // walk left
                    end
                    // keep walking, no mode change
                end
            end
            // If none of above, modes remain unchanged (should not happen)
        end
        // else splatted mode active: outputs all zero, no mode changes until reset
    end

    // Outputs: Moore outputs depend only on current mode and direction
    assign walk_left  = walking && (direction == 1'b0) && !splatted;
    assign walk_right = walking && (direction == 1'b1) && !splatted;
    assign aaah       = falling && !splatted;
    assign digging    = digging_mode && !splatted;

endmodule