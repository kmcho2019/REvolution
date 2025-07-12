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

reg [4:0] fall_count;
reg [1:0] direction; // 0: left, 1: right
reg is_digging;
reg is_falling;
reg is_splattered;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        fall_count <= 0;
        direction <= 0;
        is_digging <= 0;
        is_falling <= 0;
        is_splattered <= 0;
    end else begin
        if (is_splattered) begin
            // Do nothing
        end else if (ground) begin
            if (is_falling) begin
                is_falling <= 0;
                if (fall_count > 20) begin
                    is_splattered <= 1;
                end
            end
            if (is_digging) begin
                is_digging <= 0;
            end
            if (dig && !is_digging) begin
                is_digging <= 1;
            end
            if (is_digging && ground == 0) begin
                is_falling <= 1;
            end
            if (bump_left && bump_right) begin
                direction <= ~direction;
            end else if (bump_left) begin
                direction <= 1;
            end else if (bump_right) begin
                direction <= 0;
            end
        end else begin
            if (!is_falling) begin
                is_falling <= 1;
            end
            fall_count <= fall_count + 1;
        end
    end
end

assign walk_left = (!is_splattered && !is_falling && !is_digging && direction == 0);
assign walk_right = (!is_splattered && !is_falling && !is_digging && direction == 1);
assign aaah = is_falling;
assign digging = !is_splattered && is_digging;

endmodule