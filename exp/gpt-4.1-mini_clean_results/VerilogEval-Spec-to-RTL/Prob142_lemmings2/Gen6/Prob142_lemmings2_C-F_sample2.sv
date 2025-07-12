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

    // State registers: falling and direction
    reg falling;       // 1 = falling, 0 = walking
    reg direction;     // 0 = left, 1 = right

    // Next state signals
    reg next_falling;
    reg next_direction;

    // Combinational logic for next state
    always @(*) begin
        // Default: hold current state
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // While falling, only ground affects falling state
            if (ground)
                next_falling = 1'b0;  // stop falling, resume walking same direction
            // direction unchanged while falling
        end else begin
            // Walking
            if (!ground) begin
                next_falling = 1'b1; // start falling, direction unchanged
            end else begin
                // On ground and walking, bumps update direction
                if (bump_left && bump_right) begin
                    next_direction = ~direction; // flip direction
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end
                // else keep direction
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // walking
            direction <= 1'b0; // walk left
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