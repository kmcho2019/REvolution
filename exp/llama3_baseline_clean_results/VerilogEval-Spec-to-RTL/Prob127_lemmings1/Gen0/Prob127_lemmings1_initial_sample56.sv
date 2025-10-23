module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // 0: walking left, 1: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to walking left
        walk_left <= 1;
        walk_right <= 0;
    end else begin
        if (bump_left) begin
            state <= 1; // Switch to walking right
            walk_left <= 0;
            walk_right <= 1;
        end else if (bump_right) begin
            state <= 0; // Switch to walking left
            walk_left <= 1;
            walk_right <= 0;
        end else if (bump_left && bump_right) begin
            // If both bumps are high, switch direction
            state <= ~state;
            if (state == 0) begin
                walk_left <= 1;
                walk_right <= 0;
            end else begin
                walk_left <= 0;
                walk_right <= 1;
            end
        end
    end
end

endmodule