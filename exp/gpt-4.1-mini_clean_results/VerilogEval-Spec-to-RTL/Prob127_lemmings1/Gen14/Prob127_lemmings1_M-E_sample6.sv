module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Define states with localparams
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state combinational logic using a single boolean expression
    // If bumped left but not right => walk right
    // If bumped right but not left => walk left
    // If bumped both sides => toggle current state
    // Otherwise hold current state
    always @(*) begin
        // bump_both indicates simultaneous bump left and right
        wire bump_both = bump_left & bump_right;

        // next_state logic
        next_state = (bump_left & ~bump_right)              ? WALK_RIGHT  :
                     (~bump_left & bump_right)              ? WALK_LEFT   :
                     bump_both                              ? ~state      :
                     state;
    end

    // Outputs are combinational based on current state (Moore FSM)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule