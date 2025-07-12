module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding
    reg walk_left_state;
    reg walk_right_state;
    reg walk_left_next;
    reg walk_right_next;

    // Next state logic based on bump inputs and current state
    always @(*) begin
        // Default to hold current state
        walk_left_next  = walk_left_state;
        walk_right_next = walk_right_state;

        // If bumped on left, must walk right
        if (bump_left) begin
            walk_left_next  = 1'b0;
            walk_right_next = 1'b1;
        end
        // Else if bumped on right, must walk left
        else if (bump_right) begin
            walk_left_next  = 1'b1;
            walk_right_next = 1'b0;
        end
        // Else hold current state
        // (both bump_left and bump_right high also handled by bump_left condition)
    end

    // State register with asynchronous reset (active high)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1; // Initialize walking left
            walk_right_state <= 1'b0;
        end else begin
            walk_left_state  <= walk_left_next;
            walk_right_state <= walk_right_next;
        end
    end

    // Outputs are direct from one-hot states (Moore outputs)
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule