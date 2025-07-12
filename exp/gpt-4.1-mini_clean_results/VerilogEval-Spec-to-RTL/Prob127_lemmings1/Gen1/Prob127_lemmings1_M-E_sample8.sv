module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    // Asynchronous reset and state update on rising clock
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk left
        else
            state <= state ^ (bump_left | bump_right);
    end

    // Outputs: walk_left when state==0, walk_right when state==1
    assign walk_left = ~state;
    assign walk_right = state;

endmodule