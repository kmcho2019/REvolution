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

reg walk_direction; // 1 bit to represent the walking direction (1: left, 0: right)
reg is_falling; // 1 bit to indicate whether the Lemming is falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b1; // reset to walking left
        is_falling <= 1'b0;
    end else begin
        if (~ground) begin
            is_falling <= 1'b1; // start falling when ground disappears
        end else begin
            is_falling <= 1'b0; // stop falling when ground reappears
            if (bump_left) begin
                walk_direction <= 1'b0; // turn right when bumped from left
            end else if (bump_right) begin
                walk_direction <= 1'b1; // turn left when bumped from right
            end
        end
    end
end

// Output logic
always @(*) begin
    walk_left = (~is_falling) && walk_direction;
    walk_right = (~is_falling) && (~walk_direction);
    aaah = is_falling;
end

endmodule