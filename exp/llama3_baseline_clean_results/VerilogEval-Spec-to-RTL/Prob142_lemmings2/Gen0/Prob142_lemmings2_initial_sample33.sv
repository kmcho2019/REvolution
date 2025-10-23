module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg state;  // 0: walking left, 1: walking right
reg prev_state;  // previous walking direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;  // reset to walking left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else if (!ground) begin
        // falling, don't change direction
        aaah <= 1;
        walk_left <= 0;
        walk_right <= 0;
    end else begin
        aaah <= 0;
        if (bump_left && !bump_right) begin
            state <= 1;  // switch to walking right
        end else if (!bump_left && bump_right) begin
            state <= 0;  // switch to walking left
        end else if (bump_left && bump_right) begin
            // switch direction
            state <= ~state;
        end
        // update walk_left and walk_right based on state
        walk_left <= !state;
        walk_right <= state;
    end
end

endmodule