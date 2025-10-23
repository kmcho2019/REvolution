module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    // Next state logic as combinational boolean expression
    wire next_state;
    assign next_state = (state == WALK_LEFT) ? (bump_left ? WALK_RIGHT : WALK_LEFT)
                                            : (bump_right ? WALK_LEFT : WALK_RIGHT);

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs derived directly from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule