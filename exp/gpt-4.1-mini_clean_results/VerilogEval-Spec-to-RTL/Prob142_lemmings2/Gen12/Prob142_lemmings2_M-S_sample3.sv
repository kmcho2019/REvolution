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

    reg direction; // 0=left, 1=right
    reg falling;   // 0=walking, 1=falling

    reg next_direction;
    reg next_falling;

    always @* begin
        // Default next state is current state
        next_direction = direction;
        next_falling   = falling;

        if (falling) begin
            // Falling: ignore bumps, wait for ground
            if (ground)
                next_falling = 1'b0; // stop falling, resume walking same direction
        end else begin
            // Walking
            if (!ground) begin
                next_falling = 1'b1; // start falling
            end else begin
                // On ground and walking: update direction on bumps
                if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling   <= 1'b0; // not falling
        end else begin
            direction <= next_direction;
            falling   <= next_falling;
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule