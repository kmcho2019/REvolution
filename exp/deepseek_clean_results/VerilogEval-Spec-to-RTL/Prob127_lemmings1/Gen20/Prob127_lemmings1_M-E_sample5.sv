module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;  // Direction toggle bit (0=left, 1=right)
    wire toggle_next;

    // Toggle whenever we get any bump
    assign toggle_next = toggle ^ (bump_left | bump_right);

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            toggle <= 1'b0;
        else
            toggle <= toggle_next;
    end

    // Output assignments
    assign walk_left = ~toggle;
    assign walk_right = toggle;

endmodule