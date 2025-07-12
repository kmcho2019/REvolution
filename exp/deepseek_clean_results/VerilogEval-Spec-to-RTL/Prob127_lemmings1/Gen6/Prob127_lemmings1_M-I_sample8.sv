module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding parameters
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;

    reg state;  // Current state

    // Next state logic: XOR current state with bump signal
    wire next_state = state ^ (bump_left | bump_right);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;  // Reset to WALK_LEFT
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule