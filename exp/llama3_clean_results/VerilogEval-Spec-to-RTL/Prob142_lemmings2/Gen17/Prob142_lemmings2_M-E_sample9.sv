module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg walk_dir; // 1 bit to represent walking direction (0: left, 1: right)
reg is_falling; // 1 bit to represent falling state (0: not falling, 1: falling)
reg next_walk_dir;
reg next_is_falling;

// Combinational logic for top-level state machine (walking direction)
always @(*) begin
    next_walk_dir = walk_dir;

    if (~ground) begin
        // do nothing, let the sub-state machine handle falling
    end else if (bump_left && ~walk_dir) begin
        next_walk_dir = 1'b1; // switch to walking right
    end else if (bump_right && walk_dir) begin
        next_walk_dir = 1'b0; // switch to walking left
    end
end

// Combinational logic for sub-state machine (falling)
always @(*) begin
    next_is_falling = is_falling;

    if (~ground) begin
        next_is_falling = 1'b1; // start falling
    end else begin
        next_is_falling = 1'b0; // stop falling
    end
end

// Sequential logic to update states
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
        is_falling <= 1'b0; // reset to not falling
    end else begin
        walk_dir <= next_walk_dir;
        is_falling <= next_is_falling;
    end
end

// Output logic using assign statements
assign walk_left = (~walk_dir) && (~is_falling);
assign walk_right = walk_dir && (~is_falling);
assign aaah = is_falling;

endmodule