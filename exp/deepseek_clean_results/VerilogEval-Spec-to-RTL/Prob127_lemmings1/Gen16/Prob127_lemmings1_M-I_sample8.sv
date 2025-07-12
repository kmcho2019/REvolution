module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right

    // Combined state transition and register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else if (bump_left ^ bump_right)  // XOR - if either bump occurs (but not both)
            state <= bump_left;           // bump_left=1 means go right, bump_right=1 means go left
        // else maintain state
    end

    // Output assignments (could be combined into single output if interface allowed)
    assign walk_left = ~state;
    assign walk_right = state;

endmodule