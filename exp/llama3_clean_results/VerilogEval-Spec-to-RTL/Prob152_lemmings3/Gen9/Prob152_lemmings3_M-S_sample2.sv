module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg walking; // 1: walking, 0: falling
reg walk_direction; // 0: left, 1: right
reg is_digging;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walking <= 1; // walking
        walk_direction <= 0; // left
        is_digging <= 0;
    end else begin
        if (!ground) begin
            walking <= 0; // falling
            is_digging <= 0;
        end else if (dig &&!is_digging) begin
            is_digging <= 1;
        end else if (is_digging &&!ground) begin
            is_digging <= 0;
        end
        if (bump_left && walking) begin
            walk_direction <= 1; // right
        end else if (bump_right && walking) begin
            walk_direction <= 0; // left
        end
        if (ground &&!walking) begin
            walking <= 1; // walking
        end
    end
end

always_comb begin
    walk_left = walking &&!walk_direction? 1'b1 : 1'b0;
    walk_right = walking && walk_direction? 1'b1 : 1'b0;
    aaah =!walking? 1'b1 : 1'b0;
    digging = is_digging? 1'b1 : 1'b0;
end

endmodule