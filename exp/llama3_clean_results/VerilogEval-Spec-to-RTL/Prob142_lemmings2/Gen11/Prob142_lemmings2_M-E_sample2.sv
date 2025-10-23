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

// Sequential logic to update the walking direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
    end else if (bump_left && !falling) begin
        walk_dir <= 1'b1; // switch to walking right
    end else if (bump_right && !falling) begin
        walk_dir <= 1'b0; // switch to walking left
    end
end

// Sequential logic to update the falling state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        falling <= 1'b0; // reset to not falling
    end else if (~ground && !falling) begin
        falling <= 1'b1; // start falling
    end else if (ground && falling) begin
        falling <= 1'b0; // stop falling
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