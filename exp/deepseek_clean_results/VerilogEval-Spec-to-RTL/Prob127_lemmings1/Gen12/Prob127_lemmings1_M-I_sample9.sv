module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: walk_left, 1: walk_right

    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk_left
        end else if (bump_left || (state && bump_right)) begin
            state <= 1'b1;  // Switch to walk_right
        end else if (bump_right || (!state && bump_left)) begin
            state <= 1'b0;  // Switch to walk_left
        end
    end

    // Output logic remains unchanged (optimal)
    assign walk_left = ~state;
    assign walk_right = state;

endmodule