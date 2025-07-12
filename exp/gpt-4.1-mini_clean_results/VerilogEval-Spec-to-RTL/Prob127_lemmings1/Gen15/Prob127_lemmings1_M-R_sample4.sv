module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;
    reg next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state logic with explicit if-else for clarity
    always @(*) begin
        if (bump_left & bump_right) begin
            // Both sides bumped: toggle state
            next_state = ~state;
        end else if (bump_left) begin
            // Bumped left only: walk right
            next_state = 1'b1;
        end else if (bump_right) begin
            // Bumped right only: walk left
            next_state = 1'b0;
        end else begin
            // No bump: hold current state
            next_state = state;
        end
    end

    // Moore outputs based on state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule