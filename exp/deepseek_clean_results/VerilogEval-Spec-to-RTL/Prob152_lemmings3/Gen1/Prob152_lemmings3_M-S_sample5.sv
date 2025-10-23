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

    // State encoding
    reg walking_left;  // 1=left, 0=right
    reg is_falling;    // 1=falling, 0=not falling
    reg is_digging;    // 1=digging, 0=not digging

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_left <= 1;
            is_falling <= 0;
            is_digging <= 0;
        end else begin
            // Handle falling first (highest priority)
            if (~ground) begin
                is_falling <= 1;
                is_digging <= 0;
            end
            // Then handle landing from fall
            else if (is_falling) begin
                is_falling <= 0;
            end
            // Then handle digging
            else if (dig & ground & ~is_falling) begin
                is_digging <= 1;
            end
            // Then handle bumps (only when walking normally)
            else if (~is_falling & ~is_digging) begin
                if (bump_left) walking_left <= 0;
                if (bump_right) walking_left <= 1;
                // Handle simultaneous bumps
                if (bump_left & bump_right) walking_left <= ~walking_left;
            end
            // Stop digging when ground disappears
            if (is_digging & ~ground) begin
                is_digging <= 0;
                is_falling <= 1;
            end
        end
    end

    // Output logic
    assign walk_left = walking_left & ~is_falling & ~is_digging;
    assign walk_right = ~walking_left & ~is_falling & ~is_digging;
    assign aaah = is_falling;
    assign digging = is_digging;

endmodule