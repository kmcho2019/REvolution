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

reg walk_direction; // 1 bit to represent walking direction (0: left, 1: right)
reg falling; // 1 bit to represent falling state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        if (~ground) begin
            falling <= 1'b1;
        end else if (falling) begin
            falling <= 1'b0;
        end else if (bump_left && !bump_right) begin
            walk_direction <= 1'b1; // turn right
        end else if (bump_right && !bump_left) begin
            walk_direction <= 1'b0; // turn left
        end
    end
end

// Output logic
assign walk_left = (~falling && ~walk_direction);
assign walk_right = (~falling && walk_direction);
assign aaah = falling;

endmodule