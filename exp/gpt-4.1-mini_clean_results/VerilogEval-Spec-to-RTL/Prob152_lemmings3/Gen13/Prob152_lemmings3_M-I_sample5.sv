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

// One-hot encoding for mode
reg walk_mode, fall_mode, dig_mode;
reg dir; // 0 = left, 1 = right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_mode <= 1'b1;
        fall_mode <= 1'b0;
        dig_mode  <= 1'b0;
        dir       <= 1'b0; // start walking left
    end else begin
        // Default: hold states
        walk_mode <= walk_mode;
        fall_mode <= fall_mode;
        dig_mode  <= dig_mode;
        dir       <= dir;

        // Mode transitions with priority fall > dig > switch direction
        if (walk_mode) begin
            if (!ground) begin
                // fall has highest priority
                walk_mode <= 1'b0;
                fall_mode <= 1'b1;
            end else if (dig) begin
                // dig if ground and dig signal and not falling
                walk_mode <= 1'b0;
                dig_mode  <= 1'b1;
            end else if (bump_left || bump_right) begin
                // switch directions on bump while walking
                if (bump_left && bump_right)
                    dir <= ~dir;
                else if (bump_left)
                    dir <= 1'b1; // walk right
                else
                    dir <= 1'b0; // walk left
            end
        end else if (fall_mode) begin
            if (ground) begin
                // recover to walking in original direction
                fall_mode <= 1'b0;
                walk_mode <= 1'b1;
            end
        end else if (dig_mode) begin
            if (!ground) begin
                // start falling after digging off edge
                dig_mode  <= 1'b0;
                fall_mode <= 1'b1;
            end
        end
    end
end

assign walk_left  = walk_mode && (dir == 1'b0);
assign walk_right = walk_mode && (dir == 1'b1);
assign aaah       = fall_mode;
assign digging    = dig_mode;

endmodule