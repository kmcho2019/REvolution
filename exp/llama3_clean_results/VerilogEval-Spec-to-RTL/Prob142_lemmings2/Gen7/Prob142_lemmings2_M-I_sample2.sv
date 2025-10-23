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

reg walk_dir; // 0: left, 1: right
reg prev_walk_dir; // 0: left, 1: right
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    reg next_walk_dir;
    next_walk_dir = walk_dir;

    if (~falling) begin
        if (bump_left && bump_right) begin
            next_walk_dir = ~walk_dir;
        end else if (bump_left) begin
            next_walk_dir = 1'b1;
        end else if (bump_right) begin
            next_walk_dir = 1'b0;
        end
    end

    walk_left = ~next_walk_dir;
    walk_right = next_walk_dir;
    aaah = falling;
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
        prev_walk_dir <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        if (~ground) begin
            falling <= 1'b1;
            prev_walk_dir <= walk_dir;
        end else if (ground && falling) begin
            falling <= 1'b0;
            walk_dir <= prev_walk_dir;
        end else if (~falling) begin
            if (bump_left && bump_right) begin
                walk_dir <= ~walk_dir;
            end else if (bump_left) begin
                walk_dir <= 1'b1;
            end else if (bump_right) begin
                walk_dir <= 1'b0;
            end
        end
    end
end

endmodule