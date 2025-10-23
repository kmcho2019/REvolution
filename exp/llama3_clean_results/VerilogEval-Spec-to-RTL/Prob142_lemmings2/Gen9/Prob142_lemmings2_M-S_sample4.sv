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
reg falling; // 1: falling, 0: walking

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1; // reset to walking left
        falling <= 1'b0;
    end else begin
        if (ground) begin
            if (falling) begin
                falling <= 1'b0; // stop falling
            end else if (bump_left || bump_right) begin
                walking_left <= ~walking_left; // change walking direction
            end
        end else begin
            falling <= 1'b1; // start falling
        end
    end
end

// Output logic
always @(*) begin
    if (falling) begin
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