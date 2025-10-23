module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register (0=left, 1=right)
    reg state;

    // Priority-based direction change with efficient logic
    // Explicit about priority when both bumps occur
    wire next_state = (state & ~bump_right) | (~state & bump_left);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to walk left
        else
            state <= next_state;
    end

    // Symmetric output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule