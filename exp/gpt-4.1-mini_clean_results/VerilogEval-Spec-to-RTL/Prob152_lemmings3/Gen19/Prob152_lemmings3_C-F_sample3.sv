module TopModule(
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

    // State encoding:
    // dir_mode[1] = mode: 0=walk, 1=fall
    // dir_mode[0] = direction: 0=left, 1=right
    reg [1:0] dir_mode;
    reg       digging_r;

    wire mode      = dir_mode[1];
    wire direction = dir_mode[0];

    // Next state signals
    reg [1:0] dir_mode_next;
    reg       digging_next;

    always @(*) begin
        // Default: hold state
        dir_mode_next = dir_mode;
        digging_next  = digging_r;

        if (!ground) begin
            // Priority 1: fall if no ground
            dir_mode_next = {1'b1, direction}; // set mode=fall, preserve direction
            digging_next  = 1'b0;               // stop digging while falling
        end else if (mode == 1'b1) begin
            // Ground reappeared and was falling: go back to walking same direction, no digging
            dir_mode_next = {1'b0, direction}; // mode=walk
            digging_next  = 1'b0;
        end else begin
            // mode == walk and ground == 1
            if (digging_r) begin
                // Continue digging until ground lost (but ground is present here, so keep digging)
                digging_next = 1'b1;
                dir_mode_next = dir_mode; // no change
            end else begin
                // Not digging: check dig input or bumps
                if (dig) begin
                    // Start digging only if walking on ground
                    digging_next = 1'b1;
                    dir_mode_next = dir_mode; // keep walking direction and mode
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump (when walking and not digging)
                    // Both bumps flips direction
                    if (bump_left && bump_right) begin
                        dir_mode_next = {1'b0, ~direction};
                    end else if (bump_left) begin
                        dir_mode_next = {1'b0, 1'b1}; // walk right
                    end else begin // bump_right
                        dir_mode_next = {1'b0, 1'b0}; // walk left
                    end
                    digging_next = 1'b0;
                end else begin
                    // Keep walking same direction, no digging
                    dir_mode_next = dir_mode;
                    digging_next = 1'b0;
                end
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir_mode   <= 2'b00; // walk left
            digging_r  <= 1'b0;
        end else begin
            dir_mode   <= dir_mode_next;
            digging_r  <= digging_next;
        end
    end

    // Outputs (Moore)
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule