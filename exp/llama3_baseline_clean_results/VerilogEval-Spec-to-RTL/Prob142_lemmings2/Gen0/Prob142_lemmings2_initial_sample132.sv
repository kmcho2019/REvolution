module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg is_walking_left;
reg is_falling;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        is_walking_left <= 1;
        is_falling <= 0;
    end else begin
        if (~ground) begin
            is_walking_left <= is_walking_left;
            is_falling <= 1;
        end else if (is_falling) begin
            is_walking_left <= is_walking_left;
            is_falling <= 0;
        end else begin
            if (bump_left && bump_right) begin
                is_walking_left <= ~is_walking_left;
            end else if (bump_left) begin
                is_walking_left <= 0;
            end else if (bump_right) begin
                is_walking_left <= 1;
            end else begin
                is_walking_left <= is_walking_left;
            end
            is_falling <= 0;
        end
    end
end

always @(is_walking_left, is_falling, bump_left, bump_right, ground) begin
    walk_left = (is_walking_left && ~is_falling);
    walk_right = (~is_walking_left && ~is_falling);
    aaah = is_falling;
end

endmodule