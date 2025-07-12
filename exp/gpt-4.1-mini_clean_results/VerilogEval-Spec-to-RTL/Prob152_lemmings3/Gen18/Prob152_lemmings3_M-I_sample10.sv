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

    // Direction: 0=left,1=right
    // Mode: 0=walk,1=fall
    reg [1:0] dir_mode; // bit1: mode, bit0: direction
    // digging flag separate
    reg digging_r;

    wire direction = dir_mode[0];
    wire mode      = dir_mode[1]; // 0=walk, 1=fall

    // Next state signals
    reg [1:0] dir_mode_next;
    reg digging_next;

    always @(*) begin
        // Default next values: hold current state
        dir_mode_next = dir_mode;
        digging_next  = digging_r;

        if (!ground) begin
            // Priority 1: Fall if no ground
            // Falling cancels digging
            dir_mode_next = {1'b1, direction}; // mode=1(fall), direction preserved
            digging_next = 1'b0;
        end else if (mode == 1'b1) begin
            // Ground returned and was falling -> walk same direction, stop digging
            dir_mode_next = {1'b0, direction}; // mode=0 (walk), direction preserved
            digging_next = 1'b0;
        end else begin
            // mode=0 walking
            if (digging_r) begin
                // Continue digging until ground lost
                // But we are on ground, so keep digging
                digging_next = 1'b1;
                dir_mode_next = dir_mode; // no direction or mode change
            end else begin
                // Not digging and walking on ground
                if (dig) begin
                    // Start digging
                    digging_next = 1'b1;
                    dir_mode_next = dir_mode; // direction and mode unchanged
                end else if (bump_left || bump_right) begin
                    // Change direction if bumped (when walking and not digging)
                    // If both bumped, flip direction
                    if (bump_left && bump_right) begin
                        dir_mode_next = {1'b0, ~direction}; // mode=0 walk, flip dir
                    end else if (bump_left) begin
                        dir_mode_next = {1'b0, 1'b1}; // walk right
                    end else begin // bump_right
                        dir_mode_next = {1'b0, 1'b0}; // walk left
                    end
                    digging_next = 1'b0;
                end else begin
                    // Keep walking same direction
                    dir_mode_next = dir_mode;
                    digging_next = 1'b0;
                end
            end
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir_mode <= 2'b00; // walk left
            digging_r <= 1'b0;
        end else begin
            dir_mode <= dir_mode_next;
            digging_r <= digging_next;
        end
    end

    // Outputs from state bits (Moore outputs)
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule