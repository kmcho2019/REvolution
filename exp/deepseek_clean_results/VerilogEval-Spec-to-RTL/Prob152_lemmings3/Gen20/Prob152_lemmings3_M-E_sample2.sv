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

    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg direction;  // Primary state (LEFT/RIGHT)
    reg is_falling; // Falling flag
    reg is_digging; // Digging flag

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= LEFT;
            is_falling <= 0;
            is_digging <= 0;
        end
        else begin
            // Handle falling first (highest priority)
            if (!ground) begin
                is_falling <= 1;
                is_digging <= 0;
            end
            else if (is_falling) begin
                is_falling <= 0;
            end
            // Then handle digging (medium priority)
            else if (!is_falling && dig && !is_digging) begin
                is_digging <= 1;
            end
            else if (is_digging && !ground) begin
                is_digging <= 0;
                is_falling <= 1;
            end
            // Finally handle direction changes (lowest priority)
            else if (!is_falling && !is_digging) begin
                if (bump_left) direction <= RIGHT;
                else if (bump_right) direction <= LEFT;
            end
        end
    end

    // Output logic
    assign walk_left = !is_falling && !is_digging && (direction == LEFT);
    assign walk_right = !is_falling && !is_digging && (direction == RIGHT);
    assign aaah = is_falling;
    assign digging = is_digging;

endmodule