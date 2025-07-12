module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;

    // Next state logic as combinational boolean expressions:
    // Switch to WALK_RIGHT if bumped on left
    // Switch to WALK_LEFT if bumped on right
    // If bumped both sides, toggle current state
    // Otherwise hold state
    wire bump_both = bump_left & bump_right;
    wire next_state_from_bumps = bump_both ? ~state :
                                 bump_left ? WALK_RIGHT :
                                 bump_right ? WALK_LEFT :
                                 state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state_from_bumps;
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule