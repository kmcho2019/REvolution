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

// Combinational logic to determine the next direction and falling state
always @(*) begin
    walk_dir = walk_dir;
    falling = falling;

    if (~ground) begin
        falling = 1'b1; // falling
    end else if (ground && falling) begin
        falling = 1'b0; // not falling
    end else if ((bump_left && ~walk_dir) || (bump_right && walk_dir)) begin
        walk_dir = ~walk_dir; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b1; // reset to walking left
        falling <= 1'b0; // not falling
    end else begin
        walk_dir <= walk_dir;
        falling <= falling;
    end
end

// Output logic
assign walk_left = walk_dir & ~falling;
assign walk_right = ~walk_dir & ~falling;
assign aaah = falling;

endmodule