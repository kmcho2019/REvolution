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

    // Separate FSM state and direction signals
    reg falling;        // 1 = falling, 0 = walking
    reg direction;      // 0 = left, 1 = right

    // Next state signals
    reg next_falling;
    reg next_direction;

    // Combinational next-state logic
    always @(*) begin
        // Default: maintain current state
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // While falling, ignore bumps, only ground affects falling
            if (ground)
                next_falling = 1'b0;  // stop falling, resume walking same direction
            // else remain falling
            // direction unchanged
        end else begin
            // Walking
            if (!ground) begin
                // start falling, direction unchanged
                next_falling = 1'b1;
            end else begin
                // on ground and walking, bumps control direction
                if (bump_left && bump_right) begin
                    // flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_direction = 1'b0;
                end
                // else keep direction
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // walking
            direction <= 1'b0;  // walk left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule