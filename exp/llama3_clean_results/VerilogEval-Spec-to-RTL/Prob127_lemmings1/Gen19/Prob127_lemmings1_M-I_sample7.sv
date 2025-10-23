module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg walk_left; // Directly use walk_left as the state variable

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1; // Reset to walking left
    end else begin
        if (bump_left && !bump_right) begin
            walk_left <= 1'b0; // Switch to walking right if bumped from left
        end else if (bump_right && !bump_left) begin
            walk_left <= 1'b1; // Switch to walking left if bumped from right
        end else if (bump_left && bump_right) begin
            walk_left <= ~walk_left; // Switch direction if bumped from both sides
        end
    end
end

assign walk_right = ~walk_left; // Directly derive walk_right from walk_left

endmodule