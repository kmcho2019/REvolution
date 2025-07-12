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

reg walking_left; // 1: walking left, 0: walking right
reg is_falling; // 1: falling, 0: walking

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1; // reset to walking left
        is_falling <= 1'b0;
    end else begin
        if (~ground) begin
            is_falling <= 1'b1;
        end else if (ground && is_falling) begin
            is_falling <= 1'b0;
        end

        if (ground) begin
            if (bump_left && walking_left) begin
                walking_left <= 1'b0;
            end else if (bump_right && ~walking_left) begin
                walking_left <= 1'b1;
            end
        end
    end
end

// Output logic
always @(*) begin
    if (is_falling) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else begin
        walk_left = walking_left;
        walk_right = ~walking_left;
        aaah = 1'b0;
    end
end

endmodule