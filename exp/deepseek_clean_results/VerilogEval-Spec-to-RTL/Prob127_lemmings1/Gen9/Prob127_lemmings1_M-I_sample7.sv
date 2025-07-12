module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding (1-bit for 2 states)
    reg state;  // 0: left, 1: right

    // Next state logic - explicit about priority when both bumps occur
    wire next_state;
    assign next_state = (state == 1'b0) ? 
                      (bump_left ? 1'b1 : 1'b0) :
                      (bump_right ? 1'b0 : 1'b1);

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