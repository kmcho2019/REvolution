module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left state encoded as 0
        else
            state <= next_state;
    end

    // Next state logic: invert state if any bump detected
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Outputs: state=0 means walk_left=1, walk_right=0; state=1 means walk_right=1, walk_left=0
    assign walk_right = state;
    assign walk_left  = ~state;

endmodule