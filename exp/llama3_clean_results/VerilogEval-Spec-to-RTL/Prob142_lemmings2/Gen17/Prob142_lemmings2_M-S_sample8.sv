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

reg walk_dir; // 1: walking left, 0: walking right
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    reg next_walk_dir;
    reg next_falling;

    next_walk_dir = walk_dir;
    next_falling = falling;

    if (~ground) begin
        next_falling = 1'b1;
    end else if (falling) begin
        next_falling = 1'b0;
    end else if ((bump_left && ~walk_dir) || (bump_right && walk_dir)) begin
        next_walk_dir = ~walk_dir;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b1; // reset to walking left
        falling <= 1'b0;
    end else begin
        walk_dir <= next_walk_dir;
        falling <= next_falling;
    end
end

// Output logic
assign walk_left = walk_dir && ~falling;
assign walk_right = ~walk_dir && ~falling;
assign aaah = falling;

endmodule