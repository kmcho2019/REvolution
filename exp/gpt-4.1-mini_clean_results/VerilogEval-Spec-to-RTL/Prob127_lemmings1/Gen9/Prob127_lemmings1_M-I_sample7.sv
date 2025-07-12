module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding using localparams for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;
    wire bump_l = bump_left;
    wire bump_r = bump_right;

    // Next state logic optimized as simple if-else
    always @(*) begin
        if (bump_l && bump_r)
            next_state = ~state;            // both bumps: toggle direction
        else if (bump_l)
            next_state = WALK_RIGHT;        // bump left: walk right
        else if (bump_r)
            next_state = WALK_LEFT;         // bump right: walk left
        else
            next_state = state;             // no bumps: hold state
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs from state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule