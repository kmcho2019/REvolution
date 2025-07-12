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

// Combinational logic to determine the next state
always @(*) begin
    walk_dir = walk_dir;
    falling = falling;

    if (~ground) begin
        falling = 1'b1;
    end else if (ground && falling) begin
        falling = 1'b0;
    end

    if (~falling) begin
        if (bump_left) begin
            walk_dir = 1'b1;
        end else if (bump_right) begin
            walk_dir = 1'b0;
        end
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        walk_dir <= walk_dir;
        falling <= falling;
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