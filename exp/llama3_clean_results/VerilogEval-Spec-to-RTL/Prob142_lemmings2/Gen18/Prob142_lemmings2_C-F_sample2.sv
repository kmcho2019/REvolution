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
reg falling; // 1 bit to represent the falling state (0: not falling, 1: falling)
reg next_direction;
reg next_falling;

// Combinational logic to determine the next state
always @(*) begin
    next_direction = direction;
    next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1; // falling
    end else if (ground && falling) begin
        next_falling = 1'b0; // not falling
    end else if ((bump_left && ~direction) || (bump_right && direction)) begin
        next_direction = ~direction; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to left
        falling <= 1'b0; // reset to not falling
    end else begin
        direction <= next_direction;
        falling <= next_falling;
    end
end

// Output logic
assign walk_left = (~direction && ~falling)? 1'b1 : 1'b0;
assign walk_right = (direction && ~falling)? 1'b1 : 1'b0;
assign aaah = falling? 1'b1 : 1'b0;

endmodule