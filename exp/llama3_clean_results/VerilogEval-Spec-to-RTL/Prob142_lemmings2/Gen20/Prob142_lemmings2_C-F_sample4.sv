module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg direction; // 1 bit to represent the direction (0: left, 1: right)
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    reg next_direction;
    reg next_falling;

    next_direction = direction;
    next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1; // falling
    end else if (ground && falling) begin
        next_falling = 1'b0; // not falling
    end else if ((bump_left && ~direction) || (bump_right && direction)) begin
        next_direction = ~direction; // change direction
    end

    if (areset) begin
        next_direction = 1'b0; // reset to walking left
        next_falling = 1'b0; // reset to not falling
    end

    direction <= next_direction;
    falling <= next_falling;
end

// Output logic
always @(*) begin
    walk_left = ~direction && ~falling;
    walk_right = direction && ~falling;
    aaah = falling;
end

endmodule