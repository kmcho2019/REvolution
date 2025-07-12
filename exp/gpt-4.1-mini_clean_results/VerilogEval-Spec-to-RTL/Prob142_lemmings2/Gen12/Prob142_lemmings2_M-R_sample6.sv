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

    reg falling;   // 1 = falling, 0 = walking
    reg direction; // 0 = left, 1 = right

    // Next state signals
    reg falling_next;
    reg direction_next;

    // Combinational logic for next falling state
    always @(*) begin
        if (falling) begin
            // If currently falling, remain falling unless ground is back
            if (ground)
                falling_next = 1'b0; // Stop falling
            else
                falling_next = 1'b1; // Keep falling
        end else begin
            // If walking, start falling if no ground
            if (!ground)
                falling_next = 1'b1;
            else
                falling_next = 1'b0;
        end
    end

    // Combinational logic for next direction
    always @(*) begin
        if (falling) begin
            // Falling: direction unchanged
            direction_next = direction;
        end else begin
            // Walking: direction changes only on bumps
            if (bump_left && bump_right)
                direction_next = ~direction; // Flip direction on both bumps
            else if (bump_left)
                direction_next = 1'b1; // bump left => walk right
            else if (bump_right)
                direction_next = 1'b0; // bump right => walk left
            else
                direction_next = direction; // no bump, keep direction
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // start walking
            direction <= 1'b0; // start walking left
        end else begin
            falling   <= falling_next;
            direction <= direction_next;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule