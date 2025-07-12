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

reg walk_dir; // 0: walking left, 1: walking right
reg is_falling; // 1: falling

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 0; // reset to walking left
        is_falling <= 0;
    end else begin
        if (~ground) begin
            is_falling <= 1; // falling
        end else if (ground && is_falling) begin
            is_falling <= 0; // not falling
        end

        if (~is_falling) begin
            if (bump_left && ~walk_dir) begin
                walk_dir <= 1; // walking right
            end else if (bump_right && walk_dir) begin
                walk_dir <= 0; // walking left
            end
        end
    end
end

// Output logic
always @(*) begin
    if (is_falling) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 1;
    end else begin
        walk_left = ~walk_dir;
        walk_right = walk_dir;
        aaah = 0;
    end
end

endmodule