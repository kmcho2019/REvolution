module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state flip-flops
    reg walk_left_state;
    reg walk_right_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1; // reset to walking left
            walk_right_state <= 1'b0;
        end else begin
            // State transition logic:
            // If bump_left is asserted => walk right
            // If bump_right is asserted => walk left
            // If both bump => toggle current direction
            // If no bump => hold state
            if (bump_left && bump_right) begin
                // toggle states
                walk_left_state  <= walk_right_state;
                walk_right_state <= walk_left_state;
            end else if (bump_left) begin
                walk_left_state  <= 1'b0;
                walk_right_state <= 1'b1;
            end else if (bump_right) begin
                walk_left_state  <= 1'b1;
                walk_right_state <= 1'b0;
            end else begin
                // hold state
                walk_left_state  <= walk_left_state;
                walk_right_state <= walk_right_state;
            end
        end
    end

    // Moore outputs equal to the current one-hot state bits
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule