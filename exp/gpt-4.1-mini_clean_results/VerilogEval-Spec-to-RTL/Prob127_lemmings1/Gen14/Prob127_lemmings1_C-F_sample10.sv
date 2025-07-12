module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;
    wire bump_l = bump_left;
    wire bump_r = bump_right;

    // Combinational logic for next state using optimized boolean expression
    // next_state = walk_right when bumped on left only, 
    // toggle when bumped on both, walk_left when bumped on right only,
    // hold state when no bumps
    always @(*) begin
        next_state = (bump_l & ~bump_r)                  // bump_left only => walk_right
                   | (bump_l & bump_r & ~state)          // both bumps => toggle state
                   | (~bump_l & ~bump_r & state);        // no bumps => hold
        // bump_right only => next_state = 0 (WALK_LEFT) implicitly by omission, so no explicit term needed
    end

    // Sequential logic with asynchronous positive edge reset and non-blocking assignment
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs are Moore outputs derived from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule