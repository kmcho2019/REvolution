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

    // Next state signals
    reg next_falling;
    reg next_direction;

    // Combinational next-state logic
    always @(*) begin
        // Default keep current state
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // While falling, only ground can stop falling
            if (ground)
                next_falling = 1'b0;  // stop falling, resume walking same direction
            // direction stays unchanged while falling
        end else begin
            // Walking
            if (!ground) begin
                // Ground lost => start falling, direction unchanged
                next_falling = 1'b1;
            end else begin
                // On ground and walking, bumps can change direction
                if (bump_left && bump_right) begin
                    next_direction = ~direction; // flip direction
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end
                // else direction unchanged
            end
        end
    end

    // Sequential logic with asynchronous reset and simple update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // start walking
            direction <= 1'b0;  // start walking left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs driven from registers
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule