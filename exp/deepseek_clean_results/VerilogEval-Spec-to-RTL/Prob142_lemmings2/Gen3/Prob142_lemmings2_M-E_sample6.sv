module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg dir;        // 0=left, 1=right
    reg is_falling;  // 1 when falling
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir <= 0;        // Start walking left
            is_falling <= 0;
        end else begin
            if (!is_falling) begin
                // Only process bumps when grounded
                if (bump_left && !bump_right) dir <= 1;
                else if (bump_right && !bump_left) dir <= 0;
                // If both bumps, toggle direction
                else if (bump_left && bump_right) dir <= ~dir;
                
                // Check for falling
                if (!ground) is_falling <= 1;
            end else begin
                // In falling state
                if (ground) is_falling <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left = ~is_falling & ~dir;
    assign walk_right = ~is_falling & dir;
    assign aaah = is_falling;

endmodule