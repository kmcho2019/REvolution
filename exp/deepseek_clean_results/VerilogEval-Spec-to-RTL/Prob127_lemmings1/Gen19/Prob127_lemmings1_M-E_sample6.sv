module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle_state;  // 0 = left, 1 = right
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge, bump_right_edge;

    // Edge detection for bump signals
    assign bump_left_edge = bump_left & ~bump_left_prev;
    assign bump_right_edge = bump_right & ~bump_right_prev;

    // Toggle state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            toggle_state <= 0;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            if (bump_left_edge || bump_right_edge)
                toggle_state <= ~toggle_state;
        end
    end

    // Output assignments
    assign walk_left = ~toggle_state;
    assign walk_right = toggle_state;

endmodule