module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State bits: one-hot encoding
    reg walk_left_ff, walk_right_ff;
    reg walk_left_next, walk_right_next;

    // Asynchronous positive edge reset and sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_ff  <= 1'b1; // On reset, walk_left active
            walk_right_ff <= 1'b0;
        end else begin
            walk_left_ff  <= walk_left_next;
            walk_right_ff <= walk_right_next;
        end
    end

    // Next state logic combinational
    always @(*) begin
        // Default: hold current state
        walk_left_next  = walk_left_ff;
        walk_right_next = walk_right_ff;

        if (bump_left & bump_right) begin
            // Both bumps: toggle direction
            walk_left_next  = walk_right_ff;
            walk_right_next = walk_left_ff;
        end else if (bump_left) begin
            // Bumped left: walk right
            walk_left_next  = 1'b0;
            walk_right_next = 1'b1;
        end else if (bump_right) begin
            // Bumped right: walk left
            walk_left_next  = 1'b1;
            walk_right_next = 1'b0;
        end
        // else no bump, hold state
    end

    // Outputs directly from one-hot state bits
    assign walk_left  = walk_left_ff;
    assign walk_right = walk_right_ff;

endmodule