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

reg walking_left;
reg is_falling;
reg next_walking_left;
reg next_is_falling;

assign next_walking_left = walking_left;
assign next_is_falling = is_falling;

always @(*) begin
    if (~ground) begin
        next_is_falling = 1'b1; // falling
    end else if (ground && is_falling) begin
        next_is_falling = 1'b0; // not falling
    end

    if ((bump_left && walking_left) || (bump_right && ~walking_left)) begin
        next_walking_left = ~walking_left; // change direction
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1; // reset to walking left
        is_falling <= 1'b0; // reset to not falling
    end else begin
        walking_left <= next_walking_left;
        is_falling <= next_is_falling;
    end
end

assign walk_left = walking_left && ~is_falling;
assign walk_right = ~walking_left && ~is_falling;
assign aaah = is_falling;

endmodule