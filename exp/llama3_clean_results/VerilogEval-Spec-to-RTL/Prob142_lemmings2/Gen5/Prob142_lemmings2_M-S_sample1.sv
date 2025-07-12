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

reg walk_direction; // 0: left, 1: right
reg falling;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        walk_direction <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        if (ground == 1'b0) begin
            falling <= 1'b1; // transition to falling
        end else if (falling == 1'b1 && ground == 1'b1) begin
            falling <= 1'b0; // resume walking
        end

        if (ground == 1'b1 && (bump_left == 1'b1 || bump_right == 1'b1)) begin
            walk_direction <= ~walk_direction; // toggle walking direction
        end
    end
end

always @(*) begin
    if (falling == 1'b1) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else begin
        aaah = 1'b0;
        if (walk_direction == 1'b0) begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end else begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    end
end

endmodule