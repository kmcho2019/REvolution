module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding for clarity and maintainability
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;
    wire next_state;

    // Next state combinational logic - continuous assignment
    // If bumped on left (regardless of right bump), walk right.
    // Else if bumped on right only, walk left.
    // Else hold current state.
    assign next_state = (bump_left) ? WALK_RIGHT :
                        (bump_right) ? WALK_LEFT :
                        state;

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs from current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule