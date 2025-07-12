module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;

    wire bumped = bump_left | bump_right;

    // Next state logic: 
    // If bumped on left or right, switch directions.
    // Otherwise hold state.
    wire next_state = bumped ? ~state : state;

    // State register with asynchronous reset (posedge)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else
            state <= next_state;
    end

    // Outputs generated directly from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule