module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Direction flip-flop (0=left, 1=right)
    reg direction;

    // Toggle direction when any bump occurs
    wire toggle = bump_left | bump_right;
    wire next_direction = direction ^ toggle;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0;  // Reset to walk left
        else
            direction <= next_direction;
    end

    // Output assignments
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule