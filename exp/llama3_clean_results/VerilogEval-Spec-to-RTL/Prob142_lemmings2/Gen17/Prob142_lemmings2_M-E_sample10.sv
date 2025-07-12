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

reg walking;
reg direction; // 1: walking right, 0: walking left

// State machine controller
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking <= 1'b1; // reset to walking
        direction <= 1'b0; // reset to walking left
    end else begin
        if (~ground && walking) begin
            walking <= 1'b0; // start falling
        end else if (ground && ~walking) begin
            walking <= 1'b1; // stop falling
        end

        if (walking && (bump_left && ~direction || bump_right && direction)) begin
            direction <= ~direction; // change direction
        end
    end
end

// Output logic
always @(*) begin
    walk_left = walking && ~direction;
    walk_right = walking && direction;
    aaah = ~walking;
end

endmodule