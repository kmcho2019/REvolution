module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk left, 1 = walk right
    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk left on reset
        else
            state <= next_state;
    end

    // Next state logic: switch direction if bumped on any side
    // XOR state with (bump_left OR bump_right) to toggle direction if bumped
    always @(*) begin
        next_state = state ^ (bump_left | bump_right);
    end

    // Outputs as continuous assignments for Moore machine outputs
    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule