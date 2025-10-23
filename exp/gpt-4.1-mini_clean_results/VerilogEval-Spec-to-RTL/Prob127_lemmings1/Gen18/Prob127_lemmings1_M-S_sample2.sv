module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // Asynchronous positive edge reset to walk_left (0)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Next state logic:
    // If bump_left and bump_right both: toggle state
    // Else if bump_left only: walk_right (1)
    // Else if bump_right only: walk_left (0)
    // Else: hold current state
    always @(*) begin
        if (bump_left && bump_right)
            next_state = ~state;
        else if (bump_left)
            next_state = 1'b1;
        else if (bump_right)
            next_state = 1'b0;
        else
            next_state = state;
    end

    // Outputs derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule