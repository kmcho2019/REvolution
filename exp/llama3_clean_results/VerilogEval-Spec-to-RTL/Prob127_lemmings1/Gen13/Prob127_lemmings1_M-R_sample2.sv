module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset to LEFT state
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if ((bump_left && !bump_right && state == 1'b0) || (bump_right && state == 1'b1)) begin
            state <= 1'b1; // Switch to RIGHT state if bumped on the left while walking left or on the right while walking right
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else if ((bump_right && !bump_left && state == 1'b1) || (bump_left && state == 1'b0)) begin
            state <= 1'b0; // Switch to LEFT state if bumped on the right while walking right or on the left while walking left
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (bump_left && bump_right) begin
            state <= ~state; // Switch direction if bumped on both sides
            walk_left <= ~state;
            walk_right <= state;
        end
    end
end

endmodule