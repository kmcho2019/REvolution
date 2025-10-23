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

    // OR-based direction change logic
    wire change_dir = (state ? bump_right : bump_left);
    wire next_state = state | change_dir;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to walk left
        else if (change_dir)
            state <= ~state;
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule