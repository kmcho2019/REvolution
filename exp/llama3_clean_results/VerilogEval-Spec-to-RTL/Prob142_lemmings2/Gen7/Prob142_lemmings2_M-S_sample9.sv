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
reg prev_ground; // previous value of ground

// Sequential logic to update the walk direction and previous ground
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0; // reset to walking left
        prev_ground <= 1'b1; // reset previous ground to 1
    end else begin
        if (ground == 1'b0) begin
            prev_ground <= ground;
        end else if (prev_ground == 1'b0 && ground == 1'b1) begin
            // do nothing, just changed from falling to walking
        end else if (bump_left && walk_direction == 1'b0) begin
            // do nothing, already walking left
        end else if (bump_right && walk_direction == 1'b1) begin
            // do nothing, already walking right
        end else if (bump_left || bump_right) begin
            walk_direction <= ~walk_direction; // switch direction
        end
    end
end

// Output logic
assign walk_left = walk_direction == 1'b0;
assign walk_right = walk_direction == 1'b1;
assign aaah = ~ground;

endmodule