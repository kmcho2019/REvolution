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

    // Registers for direction (0=left,1=right), falling, digging
    reg direction;
    reg falling;
    reg digging_reg;

    // Next state signals
    reg next_direction;
    reg next_falling;
    reg next_digging;

    // Combinational next state logic
    always @(*) begin
        // Default to current state
        next_direction = direction;
        next_falling = falling;
        next_digging = digging_reg;

        // Priority: fall > dig > bump

        if (!ground) begin
            // No ground: start falling, digging stops
            next_falling = 1'b1;
            next_digging = 1'b0;
            // direction unchanged while falling
            next_direction = direction;
        end else if (falling) begin
            // Was falling but ground returned: stop falling, no digging
            next_falling = 1'b0;
            next_digging = 1'b0;
            next_direction = direction;
        end else if (digging_reg) begin
            // Currently digging on ground
            if (!ground) begin
                // Lost ground during digging: start falling, stop digging
                next_falling = 1'b1;
                next_digging = 1'b0;
                next_direction = direction;
            end else begin
                // Continue digging
                next_digging = 1'b1;
                next_falling = 1'b0;
                next_direction = direction;
            end
        end else begin
            // Walking on ground, not digging
            next_falling = 1'b0;
            next_digging = dig ? 1'b1 : 1'b0;

            if (bump_left && bump_right) begin
                // Both bumps invert direction
                next_direction = ~direction;
            end else if (bump_left) begin
                // bump left -> walk right
                next_direction = 1'b1;
            end else if (bump_right) begin
                // bump right -> walk left
                next_direction = 1'b0;
            end else begin
                // no bump, direction unchanged
                next_direction = direction;
            end
        end
    end

    // Sequential update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;     // walk left
            falling <= 1'b0;
            digging_reg <= 1'b0;
        end else begin
            direction <= next_direction;
            falling <= next_falling;
            digging_reg <= next_digging;
        end
    end

    // Outputs for walking direction (only when walking and not digging), falling and digging
    assign walk_left  = (~falling) && (~digging_reg) && (direction == 1'b0);
    assign walk_right = (~falling) && (~digging_reg) && (direction == 1'b1);
    assign aaah       = falling;
    assign digging    = digging_reg;

endmodule