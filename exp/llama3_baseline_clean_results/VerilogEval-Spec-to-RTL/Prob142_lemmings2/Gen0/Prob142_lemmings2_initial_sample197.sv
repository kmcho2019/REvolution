module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg direction; // 1: walking right, 0: walking left
reg falling;  // 1: falling, 0: not falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0; // reset to walking left
        falling <= 0; // reset to not falling
    end else begin
        if (!ground &&!falling) begin
            falling <= 1; // start falling
        end else if (ground && falling) begin
            falling <= 0; // stop falling
        end else if (ground &&!falling) begin
            if (bump_left &&!bump_right) begin
                direction <= 1; // walk right
            end else if (bump_right &&!bump_left) begin
                direction <= 0; // walk left
            end else if (bump_left && bump_right) begin
                direction <= ~direction; // switch direction
            end
        end
    end
end

assign walk_left =!falling &&!direction;
assign walk_right =!falling && direction;
assign aaah = falling;

endmodule