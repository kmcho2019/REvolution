module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding (0=left, 1=right)
    reg state;

    // Simplified direction change logic using OR
    wire next_state = (state) ? ~bump_right : bump_left;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to walk left
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule