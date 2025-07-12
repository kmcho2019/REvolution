module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else if (bump_left || bump_right)
            state <= ~state; // switch direction on any bump
    end

    // Moore outputs: walk_left = state == 0, walk_right = ~walk_left
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule