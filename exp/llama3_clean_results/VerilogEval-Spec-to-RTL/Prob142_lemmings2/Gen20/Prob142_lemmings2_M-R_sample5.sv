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

reg walk_direction; // 1: walking left, 0: walking right
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    if (~ground) begin
        falling = 1'b1;
    end else if (falling) begin
        falling = 1'b0;
    end else if ((bump_left && walk_direction) || (bump_right && ~walk_direction)) begin
        walk_direction = ~walk_direction; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 1'b1; // reset to walking left
        falling <= 1'b0;
    end else begin
        walk_direction <= walk_direction;
        falling <= falling;
    end
end

// Output logic
assign walk_left = ~falling && walk_direction;
assign walk_right = ~falling && ~walk_direction;
assign aaah = falling;

endmodule