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

reg current_direction;
reg previous_direction;
reg falling;

always @(*) begin
    walk_left = ~current_direction;
    walk_right = current_direction;
    aaah = falling;
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        current_direction <= 1'b0;
        previous_direction <= 1'b0;
        falling <= 1'b0;
    end else begin
        if (ground == 1'b0) begin
            falling <= 1'b1;
        end else if (falling == 1'b1) begin
            falling <= 1'b0;
            current_direction <= previous_direction;
        end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
            previous_direction <= current_direction;
            current_direction <= ~current_direction;
        end
    end
end

endmodule