module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Single bit state: 0 = left, 1 = right
    reg direction;

    // State transition: flip direction when bumped
    wire bump_occurred = bump_left | bump_right;
    wire next_direction = direction ^ bump_occurred;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0; // Reset to left
        else
            direction <= next_direction;
    end

    // Output logic
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule