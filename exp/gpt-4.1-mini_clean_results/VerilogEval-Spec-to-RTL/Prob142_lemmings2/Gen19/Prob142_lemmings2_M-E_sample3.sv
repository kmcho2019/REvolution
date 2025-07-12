module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // Separate state bits
    reg direction; // 0 = left, 1 = right
    reg falling;   // 0 = walking, 1 = falling

    // Next-state signals
    reg next_direction;
    reg next_falling;

    // Combinational logic to determine next states
    always @(*) begin
        // Default hold
        next_direction = direction;
        next_falling   = falling;

        if (falling) begin
            // If currently falling, only ground rising stops falling; bump ignored
            if (ground)
                next_falling = 1'b0; // stop falling, resume walking same direction
            // direction unchanged while falling
        end else begin
            // walking state
            if (!ground) begin
                // Ground lost: start falling, keep direction
                next_falling = 1'b1;
            end else begin
                // On ground and walking: bumps can change direction
                if (bump_left && bump_right) begin
                    // Both bumps cause direction flip
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_direction = 1'b1;
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_direction = 1'b0;
                end
                // else maintain current direction
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling   <= 1'b0; // not falling on reset
        end else begin
            direction <= next_direction;
            falling   <= next_falling;
        end
    end

    // Moore outputs directly from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule