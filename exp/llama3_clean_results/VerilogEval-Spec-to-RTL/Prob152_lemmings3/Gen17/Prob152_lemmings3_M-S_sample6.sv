module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg walk_direction; // 0: left, 1: right
reg is_digging;
reg is_falling;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 0; // left
        is_digging <= 0;
        is_falling <= 0;
    end else begin
        if (!ground) begin
            is_falling <= 1;
            is_digging <= 0;
        end else if (is_falling) begin
            is_falling <= 0;
        end else if (dig &&!is_digging) begin
            is_digging <= 1;
        end else if (is_digging &&!ground) begin
            is_digging <= 0;
        end
        if (!is_falling &&!is_digging) begin
            if (bump_left) begin
                walk_direction <= 1; // right
            end else if (bump_right) begin
                walk_direction <= 0; // left
            end
        end
    end
end

assign walk_left = (!is_falling &&!is_digging &&!walk_direction)? 1'b1 : 1'b0;
assign walk_right = (!is_falling &&!is_digging && walk_direction)? 1'b1 : 1'b0;
assign aaah = is_falling? 1'b1 : 1'b0;
assign digging = is_digging? 1'b1 : 1'b0;

endmodule