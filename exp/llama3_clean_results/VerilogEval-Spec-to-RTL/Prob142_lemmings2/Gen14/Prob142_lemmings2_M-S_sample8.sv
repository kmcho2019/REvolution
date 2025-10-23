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
    walk_dir = walk_dir;
    falling = falling;

    if (~ground) begin
        falling = 1'b1;
    end else if (ground && falling) begin
        falling = 1'b0;
    end

    if (ground && !falling) begin
        if (bump_left) begin
            walk_dir = 1'b0;
        end else if (bump_right) begin
            walk_dir = 1'b1;
        end
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b1; // reset to walking left
        falling <= 1'b0;
    end else begin
        walk_dir <= walk_dir;
        falling <= falling;
    end
end

// Output logic
assign walk_left = (~falling && walk_dir)? 1'b1 : 1'b0;
assign walk_right = (~falling && ~walk_dir)? 1'b1 : 1'b0;
assign aaah = falling? 1'b1 : 1'b0;

endmodule