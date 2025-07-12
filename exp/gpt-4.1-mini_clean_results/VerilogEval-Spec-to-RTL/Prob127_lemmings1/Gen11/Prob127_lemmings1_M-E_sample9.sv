module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state registers
    reg walk_left_state, walk_right_state;
    reg walk_left_next, walk_right_next;

    // Next state combinational logic
    always @(*) begin
        // Default hold current states
        walk_left_next  = walk_left_state;
        walk_right_next = walk_right_state;

        if (walk_left_state) begin
            // If bumped on left or right, switch to walking right
            if (bump_left | bump_right)
                walk_left_next = 1'b0;
                walk_right_next = 1'b1;
        end else begin // walking right state active
            // If bumped on left or right, switch to walking left
            if (bump_left | bump_right)
                walk_left_next = 1'b1;
                walk_right_next = 1'b0;
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1; // start walking left after reset
            walk_right_state <= 1'b0;
        end else begin
            walk_left_state  <= walk_left_next;
            walk_right_state <= walk_right_next;
        end
    end

    // Outputs directly driven by one-hot states (Moore outputs)
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule