module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg walk_dir; // 0: walking left, 1: walking right
reg prev_walk_dir; // previous walk direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 0; // walking left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        if (ground == 1) begin
            prev_walk_dir <= walk_dir;
            if (bump_left == 1 && bump_right == 0) begin
                walk_dir <= 1; // walk right
            end else if (bump_right == 1 && bump_left == 0) begin
                walk_dir <= 0; // walk left
            end else if (bump_left == 1 && bump_right == 1) begin
                walk_dir <= ~walk_dir; // switch direction
            end
            walk_left <= ~walk_dir;
            walk_right <= walk_dir;
            aaah <= 0;
        end else begin
            walk_left <= 0;
            walk_right <= 0;
            walk_dir <= prev_walk_dir; // preserve previous walk direction
            aaah <= 1;
        end
    end
end

endmodule