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

reg direction; // 0: walking left, 1: walking right
reg is_falling;

// Combinational logic to determine the next direction
always @(*) begin
    if (~ground) begin
        is_falling = 1'b1;
    end else if (is_falling && ground) begin
        is_falling = 1'b0;
    end

    if (bump_left && ~is_falling) begin
        direction = ~direction;
    end
    if (bump_right && ~is_falling) begin
        direction = ~direction;
    end
end

// Sequential logic to update the direction and is_falling signal
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to walking left
        is_falling <= 1'b0;
    end else begin
        // no need to update direction or is_falling on clock edge
    end
end

// Output logic
assign walk_left = (~is_falling && ~direction) ? 1'b1 : 1'b0;
assign walk_right = (~is_falling && direction) ? 1'b1 : 1'b0;
assign aaah = is_falling ? 1'b1 : 1'b0;

endmodule