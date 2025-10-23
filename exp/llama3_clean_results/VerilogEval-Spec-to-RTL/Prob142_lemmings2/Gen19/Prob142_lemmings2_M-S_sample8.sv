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

reg direction; // 1 bit to represent the direction (0: left, 1: right)
reg falling; // 1 bit to represent the falling state (0: not falling, 1: falling)

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to left
        falling <= 1'b0; // reset to not falling
    end else begin
        if (~ground) begin
            falling <= 1'b1; // falling
        end else if (ground && falling) begin
            falling <= 1'b0; // not falling
        end else if ((bump_left && ~direction) || (bump_right && direction)) begin
            direction <= ~direction; // change direction
        end
    end
end

// Output logic
always @(*) begin
    walk_left = ~falling && ~direction;
    walk_right = ~falling && direction;
    aaah = falling;
end

endmodule