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

reg direction; // 0 for left, 1 for right
reg is_falling; // 1 if falling, 0 if not

// Combinational logic to determine the next direction
always @(*) begin
    if (is_falling) begin
        // If falling, don't change direction
    end else if (bump_left && direction == 1'b0) begin
        // If bumped while walking left, change direction to right
    end else if (bump_right && direction == 1'b1) begin
        // If bumped while walking right, change direction to left
    end else if (bump_left && direction == 1'b1) begin
        // If bumped while walking right, change direction to left
        direction = 1'b0;
    end else if (bump_right && direction == 1'b0) begin
        // If bumped while walking left, change direction to right
        direction = 1'b1;
    end
end

// Sequential logic to update the direction and is_falling registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Reset to walking left
        is_falling <= 1'b0; // Reset to not falling
    end else begin
        if (~ground) begin
            is_falling <= 1'b1; // Start falling
        end else if (ground && is_falling) begin
            is_falling <= 1'b0; // Stop falling
        end
        if (bump_left && direction == 1'b0) begin
            direction <= 1'b1; // Change direction to right
        end else if (bump_right && direction == 1'b1) begin
            direction <= 1'b0; // Change direction to left
        end else if (bump_left && direction == 1'b1) begin
            direction <= 1'b0; // Change direction to left
        end else if (bump_right && direction == 1'b0) begin
            direction <= 1'b1; // Change direction to right
        end
    end
end

// Output logic
assign walk_left = (direction == 1'b0 && ~is_falling) ? 1'b1 : 1'b0;
assign walk_right = (direction == 1'b1 && ~is_falling) ? 1'b1 : 1'b0;
assign aaah = is_falling ? 1'b1 : 1'b0;

endmodule