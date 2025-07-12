module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // 0: walking_left, 1: walking_right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking_left
        walk_left <= 1;
        walk_right <= 0;
    end else begin
        if (bump_left) begin
            state <= 1; // switch to walking_right
        end else if (bump_right) begin
            state <= 0; // switch to walking_left
        end
        if (state == 0) begin
            walk_left <= 1;
            walk_right <= 0;
        end else begin
            walk_left <= 0;
            walk_right <= 1;
        end
    end
end

endmodule