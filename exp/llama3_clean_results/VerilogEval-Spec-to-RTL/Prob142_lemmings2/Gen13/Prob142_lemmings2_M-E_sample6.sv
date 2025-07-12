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

reg walk_dir; // 1 bit to represent the walking direction (0: left, 1: right)
reg falling; // 1 bit to represent the falling state (0: not falling, 1: falling)

// Combinational logic to determine the next walking direction
always @(*) begin
    if (bump_left && ~falling) begin
        walk_dir = 1'b1; // walk right
    end else if (bump_right && ~falling) begin
        walk_dir = 1'b0; // walk left
    end
end

// Combinational logic to determine the next falling state
always @(*) begin
    if (~ground) begin
        falling = 1'b1; // falling
    end else if (ground && falling) begin
        falling = 1'b0; // not falling
    end
end

// Sequential logic to update the walking direction and falling state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
        falling <= 1'b0; // reset to not falling
    end else begin
        walk_dir <= walk_dir; // no change
        falling <= falling; // no change
    end
end

// Output logic
always @(*) begin
    if (falling) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else if (walk_dir) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
        aaah = 1'b0;
    end else begin
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end
end

endmodule