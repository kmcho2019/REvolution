module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    wire next_state;
    wire state_change;

    // Detect when state needs to change
    assign state_change = (state & bump_right) | (~state & bump_left);

    // Simplified next state logic
    assign next_state = state_change ? ~state : state;

    // Clock gating logic
    wire gated_clk = clk & (areset | state_change);

    always @(posedge gated_clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end

    // Direct output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule