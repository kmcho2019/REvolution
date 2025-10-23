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

reg walk_direction; // 1: walk right, 0: walk left
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    reg next_walk_direction;
    reg next_falling;

    next_walk_direction = walk_direction;
    next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1; // falling
    end else if (ground && falling) begin
        next_falling = 1'b0; // not falling
    end else if ((bump_left && ~walk_direction) || (bump_right && walk_direction)) begin
        next_walk_direction = ~walk_direction; // change direction
    end

    walk_direction <= next_walk_direction;
    falling <= next_falling;
end

// Output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0; // reset to walk left
        falling <= 1'b0; // not falling
    end
end

assign walk_left = ~walk_direction && ~falling;
assign walk_right = walk_direction && ~falling;
assign aaah = falling;

endmodule