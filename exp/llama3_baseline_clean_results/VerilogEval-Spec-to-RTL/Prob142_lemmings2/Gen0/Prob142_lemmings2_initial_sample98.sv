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

reg direction; // 1 for walking right, 0 for walking left
reg falling;
reg prev_direction; // to keep track of the last known direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0; // reset to walking left
        falling <= 0;
        prev_direction <= 0;
    end else begin
        if (!ground) begin
            falling <= 1;
            prev_direction <= direction;
        end else if (falling) begin
            falling <= 0;
            direction <= prev_direction;
        end else begin
            if (bump_left && !bump_right) begin
                direction <= 1; // walk right
            end else if (bump_right && !bump_left) begin
                direction <= 0; // walk left
            end else if (bump_left && bump_right) begin
                direction <= ~direction; // switch direction
            end
        end
    end
end

assign walk_left = (!falling && !direction);
assign walk_right = (!falling && direction);
assign aaah = falling;

endmodule