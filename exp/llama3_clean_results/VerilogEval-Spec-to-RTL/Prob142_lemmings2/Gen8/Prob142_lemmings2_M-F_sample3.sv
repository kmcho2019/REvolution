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
reg is_falling; // 1: falling, 0: not falling

// Sequential logic to update the walk direction and falling state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0; // reset to walking left
        is_falling <= 1'b0; // reset not falling
    end else begin
        if (ground == 1'b0) begin
            is_falling <= 1'b1; // start falling
        end else if (ground == 1'b1 && is_falling == 1'b1) begin
            is_falling <= 1'b0; // stop falling
        end else if (is_falling == 1'b0 && (bump_left || bump_right)) begin
            walk_direction <= ~walk_direction; // switch direction
        end
    end
end

// Output logic
assign walk_left = (is_falling == 1'b0) && (walk_direction == 1'b0);
assign walk_right = (is_falling == 1'b0) && (walk_direction == 1'b1);
assign aaah = is_falling;

endmodule