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

reg walk_dir; // 1 for walking right, 0 for walking left
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    reg next_walk_dir;
    reg next_falling;

    next_walk_dir = walk_dir;
    next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1; // Falling when no ground
    end else if (~falling) begin // Not falling
        if (bump_left && walk_dir == 1'b0) begin
            next_walk_dir = 1'b1;
        end else if (bump_right && walk_dir == 1'b1) begin
            next_walk_dir = 1'b0;
        end
    end else if (falling && ground) begin // Just regained ground
        next_falling = 1'b0;
    end

    walk_dir <= next_walk_dir;
    falling <= next_falling;
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // Reset to walking left
        falling <= 1'b0;
    end
end

// Output logic
assign walk_left = (~falling && ~walk_dir)? 1'b1 : 1'b0;
assign walk_right = (~falling && walk_dir)? 1'b1 : 1'b0;
assign aaah = falling? 1'b1 : 1'b0;

endmodule