module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Next state logic expression:
    // If both bumps: toggle state
    // else if bump_left only: walk_right (1)
    // else if bump_right only: walk_left (0)
    // else hold state
    wire next_state = (bump_left & bump_right) ? ~state :
                      bump_left              ? 1'b1   :
                      bump_right             ? 1'b0   :
                                              state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Moore outputs derived from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule