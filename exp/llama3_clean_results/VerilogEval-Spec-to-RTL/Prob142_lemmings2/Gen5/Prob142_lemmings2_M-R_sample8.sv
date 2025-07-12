module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg walk_direction; // 0: left, 1: right
reg falling;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b0; // reset to walking left
        falling <= 1'b0; // reset to not falling
    end else begin
        if (bump_left || bump_right) begin
            walk_direction <= ~walk_direction; // switch direction
        end

        if (!ground &&!falling) begin
            falling <= 1'b1; // start falling
        end else if (ground && falling) begin
            falling <= 1'b0; // stop falling
        end
    end
end

assign walk_left = (!falling &&!walk_direction);
assign walk_right = (!falling && walk_direction);
assign aaah = falling;

endmodule