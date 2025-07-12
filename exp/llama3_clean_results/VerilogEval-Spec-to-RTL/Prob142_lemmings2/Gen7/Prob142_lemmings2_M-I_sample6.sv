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
reg falling;
reg prev_walk_dir;
reg next_walk_dir;

// Combinational logic to determine the next state
always @(*) begin
    next_walk_dir = walk_dir;

    if (~falling && (bump_left || bump_right)) begin
        next_walk_dir = ~walk_dir;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
        falling <= 1'b0;
        prev_walk_dir <= 1'b0;
    end else begin
        if (~ground && ~falling) begin
            prev_walk_dir <= walk_dir;
            falling <= 1'b1;
        end else if (ground && falling) begin
            falling <= 1'b0;
            walk_dir <= prev_walk_dir;
        end else if (~falling) begin
            walk_dir <= next_walk_dir;
        end
    end
end

// Output logic
always @(*) begin
    if (falling) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else begin
        walk_left = ~walk_dir;
        walk_right = walk_dir;
        aaah = 1'b0;
    end
end

endmodule