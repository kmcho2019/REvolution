module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left_state, walk_right_state;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1;  // Reset to walk left
            walk_right_state <= 1'b0;
        end else begin
            // Determine if any bump occurred
            if (bump_left || bump_right) begin
                // Switch states: if walking left, go right; if walking right, go left
                walk_left_state  <= walk_right_state;
                walk_right_state <= walk_left_state;
            end else begin
                // Hold current state
                walk_left_state  <= walk_left_state;
                walk_right_state <= walk_right_state;
            end
        end
    end

    // Outputs directly driven from one-hot states
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule