module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State registers
    reg falling;       // 1 = falling, 0 = walking
    reg direction;     // 0 = left, 1 = right

    // Next-state combinational signals
    reg next_falling;
    reg next_direction;

    // Asynchronous reset logic
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            falling   <= 1'b0;  // Reset: not falling
            direction <= 1'b0;  // Reset: walk left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Next-state logic combinational
    always @(*) begin
        // Default assignments: hold current state
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // If falling, stay falling until ground returns
            if (ground)
                next_falling = 1'b0;
            // direction unchanged while falling
        end else begin
            // Not falling
            if (!ground) begin
                next_falling = 1'b1; // start falling
            end else begin
                // On ground and walking: update direction if bumped
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end
                // else keep direction unchanged
            end
        end
    end

    // Outputs (Moore)
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule